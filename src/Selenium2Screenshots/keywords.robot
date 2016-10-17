*** Settings ***

Library  String
Library  Collections
Library  Selenium2Library
Library  Selenium2Screenshots.Image

*** Variables ***

${CROP_MARGIN} =  10

*** Keywords ***

Bootstrap jQuery
    [Documentation]  Injects jQuery into the curently active window.
    Execute Javascript
    ...    return (function(){
    ...        var script = window.document.createElement('script');
    ...        script.src = '//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js';
    ...        window.document.body.appendChild(script);
    ...        return true;
    ...    })();
    Wait until keyword succeeds  60  2  Execute Javascript
    ...    return (function(){
    ...        return typeof window.jQuery === 'function';
    ...    })();

Normalize annotation locator
    [Documentation]  Normalizes the given *Selenium2Library*-locator into
    ...              *Sizzle*-selector, which is the support selector
    ...              format in the annotation keywords.
    ...
    ...              Requires a single argument (``locator``).
    ...
    ...              Returns the normalized ``selector``.
    [Arguments]  ${locator}
    ${locator} =  Replace string  ${locator}  '  \\'

    ${method} =  Get lines matching regexp  ${locator}
    ...          ^jquery=.*|^css=.*|^id=.*
    ${locator} =  Set variable if  '${method}' == ''
    ...           id=${locator}  '${method}' != ''  ${locator}

    ${locator} =  Replace string using regexp  ${locator}  ^jquery=  ${empty}
    ${locator} =  Replace string using regexp  ${locator}  ^css=  ${empty}
    ${locator} =  Replace string using regexp  ${locator}  ^id=  \#
    [return]  ${locator}

Add pointer
    [Documentation]  Adds a round transparent dot into center of the
    ...              given ``locator``.
    ...
    ...              Requires a single argument (``locator``) and accepts the
    ...              following keyword arguments:
    ...
    ...              - ``size``, which is the size of \
    ...                the annotation element in pixels (default: ``20``)
    ...
    ...              - ``position``, which is the position-value of \
    ...                the annotation element (default: ``center``).
    ...
    ...              - ``display``, which is the display-value of \
    ...                the annotation element (default: ``block``).
    ...
    ...              Returns ``id`` of the created element.
    [Arguments]  ${locator}
    ...          ${size}=20
    ...          ${position-x}=50
    ...          ${position-y}=50
    ...          ${display}=block
    ${selector} =  Normalize annotation locator  ${locator}
    ${size} =  Replace string  ${size}  '  \\'
    ${display} =  Replace string  ${display}  '  \\'
    ${id} =  Execute Javascript
    ...    return (function(){
    ...        var id = 'robot-' + Math.random().toString().substring(2);
    ...        var annotation = jQuery('<div></div>');
    ...        var target = jQuery('${selector}');
    ...        if (target.length === 0) { return ''; }
    ...        var offset = target.offset();
    ...        var height = target.outerHeight();
    ...        var width = target.outerWidth();
    ...        annotation.attr('id', id);
    ...        annotation.css({
    ...            'display': '${display}',
    ...            'font-family': 'serif',
    ...            'text-align': 'center',
    ...            'opacity': '0.3',
    ...            '-moz-box-sizing': 'border-box',
    ...            '-webkit-box-sizing': 'border-box',
    ...            'box-sizing': 'border-box',
    ...            'position': 'absolute',
    ...            'color': 'white',
    ...            'background': 'black',
    ...            'width': '${size}px',
    ...            'height': '${size}px',
    ...            'top': (offset.top + (height * (${position-y} / 100.0))) - (${size} / 2)+'px',
    ...            'left': (offset.left + (width * (${position-x} / 100.0))) - (${size} / 2)+'px',
    ...            'border-radius': (${size} / 2).toString() + 'px',
    ...            'z-index': '9999'
    ...        });
    ...        jQuery('body').append(annotation);
    ...        return id;
    ...    })();
    Should match regexp  ${id}  ^robot-.*
    ...                  msg=${selector} was not found and no dot was created
    [return]  ${id}

Add dot
    [Documentation]  Adds a colored round dot into center of
    ...              the given ``locator``.
    ...
    ...              Requires a single argument (``locator``) and accepts the
    ...              following keyword arguments:
    ...
    ...              - ``text``, which is rendered inside \
    ...                the annotation element (defaults: ``none``)
    ...
    ...              - ``size``, which is the size of \
    ...                the annotation element in pixels (default: ``20``)
    ...
    ...              - ``background``, which is the backround color of \
    ...                the annotation element (default: ``#fcf0ad``)
    ...
    ...              - ``color``, which is the foreground color of \
    ...                the annotation element (default: ``black``)
    ...
    ...              - ``position-x``, which is the percentage position-value of \
    ...                the annotation element (default: ``50``).
    ...
    ...              - ``position-y``, which is the percentage position-value of \
    ...                the annotation element (default: ``50``).
    ...
    ...              - ``display``, which is the display-value of \
    ...                the annotation element (default: ``block``).
    ...
    ...              Returns ``id`` of the created element.
    [Arguments]  ${locator}  ${text}=${EMPTY}
    ...          ${size}=20
    ...          ${background}=#fcf0ad
    ...          ${color}=black
    ...          ${position-x}=50
    ...          ${position-y}=50
    ...          ${display}=block
    ${id} =  Add pointer  ${locator}  size=${size}  position-x=${position-x}  position-y=${position-y}  display=none
    Execute Javascript
    ...    return (function(){
    ...        jQuery('#${id}').css({
    ...            'opacity': '1',
    ...            'padding-top': '0.1em',
    ...            'box-shadow': '0 0 5px #888',
    ...            'background': '${background}',
    ...            'color': '${color}'
    ...        }).text('${text}');
    ...        return true;
    ...    })();
    Update element style  ${id}  display  ${display}
    [return]  ${id}

Add note
    [Documentation]  Adds a colored note into center of the
    ...              the given ``locator`` with the given ``text``.
    ...
    ...              Requires two arguments (``locator`` and ``text``)
    ...              and accept the following keyword arguments:
    ...
    ...              - ``width``, which is the width of \
    ...                the annotation element in pixels (default: ``140``)
    ...
    ...              - ``background``, which is the backround color of \
    ...                the annotation element (default: ``#fcf0ad``)
    ...
    ...              - ``color``, which is the foreground color of \
    ...                the annotation element (default: ``black``)
    ...
    ...              - ``border``, which is the border style of \
    ...                the annotation element (default: ``none``)
    ...
    ...              - ``display``, which is the display-value of \
    ...                the annotation element (default: ``block``)
    ...
    ...              - ``position``, which defines an alternative position \
    ...                for the annotation element relative to the given and \
    ...                must be one of the following values: \
    ...                ``top``, ``right``, ``bottom`` or ``left`` \
    ...                (default: ``none``).
    ...
    ...              Returns ``id`` of the created element.
    [Arguments]  ${locator}  ${text}
    ...          ${width}=140
    ...          ${background}=#fcf0ad
    ...          ${color}=black
    ...          ${border}=none
    ...          ${display}=block
    ...          ${position}=${EMPTY}
    ${selector} =  Normalize annotation locator  ${locator}
    ${text} =  Replace string  ${text}  '  \\'
    ${background} =  Replace string  ${background}  '  \\'
    ${color} =  Replace string  ${color}  '  \\'
    ${border} =  Replace string  ${border}  '  \\'
    ${display} =  Replace string  ${display}  '  \\'
    ${width} =  Replace string  ${width}  '  \\'
    ${position} =  Replace string  ${position}  '  \\'
    ${id} =  Execute Javascript
    ...    return (function(){
    ...        var id = 'robot-' + Math.random().toString().substring(2);
    ...        var annotation = jQuery('<div></div>');
    ...        var target = jQuery('${selector}');
    ...        if (target.length === 0) { return ''; }
    ...        var offset = target.offset();
    ...        var width = target.outerWidth();
    ...        var height = target.outerHeight();
    ...        var maxLeft = jQuery('html').width()
    ...                      - ${width} - ${CROP_MARGIN};
    ...        annotation.attr('id', id);
    ...        annotation.text('${text}');
    ...        annotation.css({
    ...            'display': 'none',
    ...            'position': 'absolute',
    ...            'font-family': 'serif',
    ...            'box-shadow': '0 0 5px #888',
    ...            '-moz-box-sizing': 'border-box',
    ...            '-webkit-box-sizing': 'border-box',
    ...            'box-sizing': 'border-box',
    ...            'padding': '0.75ex 0.5em 0.5ex 0.5em',
    ...            'border': '${border}',
    ...            'border-radius': '2px',
    ...            'background': '${background}',
    ...            'color': '${color}',
    ...            'z-index': '9999',
    ...            'width': '${width}px',
    ...            'top': Math.max(
    ...                 (offset.top + height / 2),
    ...                 ${CROP_MARGIN}
    ...            ).toString() + 'px',
    ...            'left': Math.max(${CROP_MARGIN}, Math.min(
    ...                 (offset.left + width / 2 - (${width} / 2)),
    ...                 maxLeft
    ...            )).toString() + 'px'
    ...        });
    ...        if ('${position}' === 'top') {
    ...            annotation.css({
    ...                'top': 'auto',
    ...                'bottom': (
    ...                    window.innerHeight - offset.top + ${CROP_MARGIN}
    ...                ).toString() + 'px'
    ...            });
    ...        } else if ('${position}' === 'bottom') {
    ...            annotation.css({
    ...                'top': (
    ...                    offset.top + height + ${CROP_MARGIN}
    ...                ).toString() + 'px'
    ...            });
    ...        } else if ('${position}' === 'left') {
    ...            annotation.css({
    ...                'left': (
    ...                    offset.left - ${width} - ${CROP_MARGIN} / 2
    ...                ).toString() + 'px'
    ...            });
    ...        } else if ('${position}' === 'right') {
    ...            annotation.css({
    ...                'left': (Math.min(
    ...                    offset.left + width + ${CROP_MARGIN} / 2,
    ...                    maxLeft
    ...                )).toString() + 'px'
    ...            });
    ...        }
    ...        jQuery('body').append(annotation);
    ...        if ('${position}' !== 'top' && '${position}' !== 'bottom') {
    ...            var annHeight = annotation.outerHeight();
    ...            annotation.css({
    ...                'display': '${display}',
    ...                'top': Math.max((
    ...                    offset.top + height / 2 - annHeight / 2
    ...                ), ${CROP_MARGIN}).toString() + 'px'
    ...            });
    ...        } else {
    ...            annotation.css({
    ...                'display': '${display}'
    ...            });
    ...        }
    ...        return id;
    ...    })();
    Should match regexp  ${id}  ^robot-.*
    ...                  msg=${selector} was not found and no note was created
    [return]  ${id}

Add pointy note
    [Documentation]  Adds a note with the given ``locator`` with
    ...              the given ``text`` and an arrow pointing to the
    ...              locator from the given ``position``.
    ...
    ...              Requires two arguments (``locator`` and ``text``)
    ...              and accept the following keyword arguments:
    ...
    ...              - ``width``, which is the width of \
    ...                the annotation element in pixels (default: ``140``)
    ...
    ...              - ``background``, which is the backround color of \
    ...                the annotation element (default: ``#fcf0ad``)
    ...
    ...              - ``color``, which is the foreground color of \
    ...                the annotation element (default: ``black``)
    ...
    ...              - ``position``, which defines the position \
    ...                of the annotation element relative to the given and \
    ...                must be one of the following values: \
    ...                ``top``, ``right``, ``bottom`` or ``left`` \
    ...                (default: ``bottom``).
    ...
    ...              Returns ``id`` of the created element.
    [Arguments]  ${locator}  ${text}
    ...          ${width}=140
    ...          ${background}=#fcf0ad
    ...          ${color}=black
    ...          ${border}=none
    ...          ${display}=block
    ...          ${position}=bottom
    ${id} =  Add note  ${locator}  ${text}  ${width}  ${background}
    ...                ${color}  ${border}  ${display}  ${position}
    Execute Javascript
    ...    return (function(){
    ...        var annotation = jQuery('#${id}');
    ...        var annotationWidth = annotation.outerWidth();
    ...        var annotationHeight = annotation.outerHeight();
    ...        var arrow = jQuery('<div></div>');
    ...        var background = jQuery('<div></div>');
    ...        /* These are to fix hi-res (Retina) downscaling artifacts: */
    ...        var fixH = jQuery('<div></div>');
    ...        var fixV = jQuery('<div></div>');
    ...        arrow.css({
    ...            'border-color': 'transparent',
    ...            'border-style': 'solid',
    ...            'border-width': '10px',
    ...            'height': '0',
    ...            'width': '0',
    ...            'position': 'absolute'
    ...        });
    ...        background.css({
    ...            'border-color': 'transparent',
    ...            'border-style': 'solid',
    ...            'border-width': '12px',
    ...            'height': '0',
    ...            'width': '0',
    ...            'position': 'absolute'
    ...        });
    ...        fixH.css({
    ...            'width': '24px',
    ...            'height': '2px',
    ...            'position': 'absolute',
    ...            'background': '${background}'
    ...        });
    ...        fixV.css({
    ...            'width': '2px',
    ...            'height': '24px',
    ...            'position': 'absolute',
    ...            'background': '${background}'
    ...        });
    ...        if ('${position}' === 'top') {
    ...            background.css({
    ...                'border-top-color': '#d6d6d6',
    ...                'bottom': '-23px',
    ...                'left': ((annotationWidth - 23) / 2).toString() + 'px'
    ...            }).appendTo(annotation);
    ...            arrow.css({
    ...                'border-top-color': '${background}',
    ...                'bottom': '-19px',
    ...                'left': ((annotationWidth - 19) / 2).toString() + 'px'
    ...            }).appendTo(annotation);
    ...            fixH.css({
    ...                'bottom': '0',
    ...                'left': ((annotationWidth - 24) / 2).toString() + 'px'
    ...            }).appendTo(annotation);
    ...            fixV.css({
    ...                'bottom': '-8px',
    ...                'height': '8px',
    ...                'left': ((annotationWidth - 1) / 2).toString() + 'px'
    ...            }).appendTo(annotation);
    ...        } else if ('${position}' === 'bottom') {
    ...            background.css({
    ...                'border-bottom-color': '#d6d6d6',
    ...                'top': '-23px',
    ...                'left': ((annotationWidth - 23) / 2).toString() + 'px'
    ...            }).appendTo(annotation);
    ...            arrow.css({
    ...                'border-bottom-color': '${background}',
    ...                'top': '-19px',
    ...                'left': ((annotationWidth - 19) / 2).toString() + 'px'
    ...            }).appendTo(annotation);
    ...            fixH.css({
    ...                'top': '1px',
    ...                'left': ((annotationWidth - 24) / 2).toString() + 'px'
    ...            }).appendTo(annotation);
    ...            fixV.css({
    ...                'top': '-8px',
    ...                'height': '8px',
    ...                'left': ((annotationWidth - 1) / 2).toString() + 'px'
    ...            }).appendTo(annotation);
    ...        } else if ('${position}' === 'left') {
    ...            background.css({
    ...                'border-left-color': '#d6d6d6',
    ...                'right': '-23px',
    ...                'top': ((annotationHeight - 23) / 2).toString() + 'px'
    ...            }).appendTo(annotation);
    ...            arrow.css({
    ...                'border-left-color': '${background}',
    ...                'right': '-19px',
    ...                'top': ((annotationHeight - 19) / 2).toString() + 'px'
    ...            }).appendTo(annotation);
    ...            fixH.css({
    ...                'right': '-8px',
    ...                'width': '8px',
    ...                'top': ((annotationHeight - 1) / 2).toString() + 'px'
    ...            }).appendTo(annotation);
    ...            fixV.css({
    ...                'right': '0px',
    ...                'top': ((annotationHeight - 24) / 2).toString() + 'px'
    ...            }).appendTo(annotation);
    ...        } else if ('${position}' === 'right') {
    ...            background.css({
    ...                'border-right-color': '#d6d6d6',
    ...                'left': '-23px',
    ...                'top': ((annotationHeight - 23) / 2).toString() + 'px'
    ...            }).appendTo(annotation);
    ...            arrow.css({
    ...                'border-right-color': '${background}',
    ...                'left': '-19px',
    ...                'top': ((annotationHeight - 19) / 2).toString() + 'px'
    ...            }).appendTo(annotation);
    ...            fixH.css({
    ...                'left': '-8px',
    ...                'width': '8px',
    ...                'top': ((annotationHeight - 1) / 2).toString() + 'px'
    ...            }).appendTo(annotation);
    ...            fixV.css({
    ...                'left': '0',
    ...                'top': ((annotationHeight - 24) / 2).toString() + 'px'
    ...            }).appendTo(annotation);
    ...        }
    ...        return true;
    ...    })();
    [return]  ${id}

Remove element
    [Documentation]   Removes the element with the given ``id`` from the
    ...               document.
    ...
    ...               Requires a single argument (``id``).
    [Arguments]  ${id}
    Execute Javascript
    ...    return (function(){
    ...        jQuery('#${id}').remove();
    ...        return true;
    ...    })();

Remove elements
    [Documentation]   Removes elements with the given ``ids`` from the
    ...               document.
    ...
    ...               Requires at least one argument (at least one ``id``).
    [Arguments]  @{ids}
    :FOR  ${id}  IN  @{ids}
    \  Remove element  ${id}

Update element style
    [Documentation]   Updates style for the element with the ``locator``.
    ...               Updates only one style property of the given ``name``
    ...               with the given ``value``.
    ...
    ...               Requires three arguments (``locator``, ``name`` and
    ...               ``value``).
    ...
    ...               Returns normalized ``selector`` of the updated element.
    [Arguments]  ${locator}  ${name}  ${value}
    ${selector} =  Normalize annotation locator  ${locator}
    ${name} =  Replace string  ${name}  '  \\'
    ${value} =  Replace string  ${value}  '  \\'
    Execute Javascript
    ...    return (function(){
    ...        jQuery('${selector}').css({
    ...            '${name}': '${value}'
    ...        });
    ...        return true;
    ...    })();
    [return]  ${selector}

Align elements horizontally
    [Documentation]  Aligns the elements matching the given ``locators``
    ...              so that the following elements are centered after the
    ...              first element.
    ...
    ...              Requires at least two arguments
    ...              (at least two ``locator``).
    [Arguments]  @{locators}
    @{selectors} =  Create list
    :FOR  ${locator}  IN  @{locators}
    \  ${selector} =  Normalize annotation locator  ${locator}
    \  Append to list  ${selectors}  ${selector}
    ${selectors} =  Convert to string  ${selectors}
    ${selectors} =  Replace string using regexp  ${selectors}  u'  '
    Execute Javascript
    ...    return (function(){
    ...        var selectors = ${selectors}, center=null, el, max, i;
    ...        for (i = 0; i < selectors.length; i++) {
    ...            el = jQuery(selectors[i]);
    ...            if (el.length > 0 && center === null) {
    ...                center = el.offset().left + el.outerWidth() / 2;
    ...                continue;
    ...            } else if (el.length > 0) {
    ...                max = jQuery('html').width()
    ...                    - el.outerWidth() - ${CROP_MARGIN};
    ...                el.css({
    ...                    'left': Math.max(${CROP_MARGIN}, Math.min(
    ...                        center - (el.outerWidth() / 2), max
    ...                     )).toString() + 'px'
    ...                });
    ...            }
    ...        }
    ...    })();

Crop page screenshot
    [Documentation]  Crops the given ``filename`` to
    ...              match the combined bounding box of the
    ...              elements matching the given ``locators``.
    ...
    ...              Requires at least two arguments
    ...              (``filename`` and at least one ``locator``).
    [Arguments]  ${filename}  @{locators}
    @{selectors} =  Create list
    :FOR  ${locator}  IN  @{locators}
    \  ${selector} =  Normalize annotation locator  ${locator}
    \  Append to list  ${selectors}  ${selector}
    ${selectors} =  Convert to string  ${selectors}
    ${selectors} =  Replace string using regexp  ${selectors}  u'  '
    @{dimensions} =  Execute Javascript
    ...    return (function(){
    ...        var selectors = ${selectors}, i, target, offset;
    ...        var left = null, top = null, width = null, height = null;
    ...        for (i = 0; i < selectors.length; i++) {
    ...            target = jQuery(selectors[i]);
    ...            if (target.length === 0) {
    ...                return [selectors[i], '', '', ''];
    ...            }
    ...            offset = target.offset();
    ...            if (left === null || width === null) {
    ...                width = target.outerWidth();
    ...            } else {
    ...                width = Math.max(
    ...                    left + width, offset.left + target.outerWidth()
    ...                ) - Math.min(left, offset.left);
    ...            }
    ...            if (top === null || height === null) {
    ...                height = target.outerHeight();
    ...            } else {
    ...                height = Math.max(
    ...                    top + height, offset.top + target.outerHeight()
    ...                ) - Math.min(top, offset.top);
    ...            }
    ...            if (left === null) { left = offset.left; }
    ...            else { left = Math.min(left, offset.left); }
    ...            if (top === null) { top = offset.top; }
    ...            else { top = Math.min(top, offset.top); }
    ...        }
    ...        return [Math.max(0, left - ${CROP_MARGIN}),
    ...                Math.max(0, top - ${CROP_MARGIN}),
    ...                Math.max(0, width + ${CROP_MARGIN} * 2),
    ...                Math.max(height + ${CROP_MARGIN} * 2)];
    ...    })();
    ${first} =  Convert to string  @{dimensions}[0]
    Should match regexp  ${first}  ^[\\d\\.]+$
    ...    msg=${first} was not found and no image was cropped
    Crop image  ${OUTPUT_DIR}  ${filename}  @{dimensions}

Capture viewport screenshot
    [Documentation]  Captures a page screenshot with the given ``filename`` and
    ...              crops it to match the current browser window dimensions
    ...              scroll position.
    ...
    ...              Requires a single argument (``filename``).
    [Arguments]  ${filename}
    Capture page screenshot  ${filename}
    @{dimensions} =  Execute Javascript
    ...    return (function(){
    ...        var w = window, d = document, e = d.documentElement,
    ...            g = d.getElementsByTagName('body')[0], x = 0, y = 0,
    ...            width = w.innerWidth || e.clientWidth || g.clientWidth,
    ...            height = w.innerHeight || e.clientHeight || g.clientHeight;
    ...        if (typeof pageYOffset != 'undefined') { y = pageYOffset; }
    ...        else {
    ...           if (e.clientHeight) { y = e.scrollTop; /* IE 'stdsmode' */ }
    ...           else { y = d.body.scrollTop; /* IE 'quirksmode' */ }
    ...        }
    ...        return [x, y, width, height];
    ...    })();
    Crop image  ${OUTPUT_DIR}  ${filename}  @{dimensions}

Capture and crop page screenshot
    [Documentation]  Captures a page screenshot with the given ``filename`` and
    ...              crops it to match the combined bounding box of the
    ...              elements matching the given ``locators``.
    ...
    ...              Requires at least two arguments
    ...              (``filename`` and at least one ``locator``).
    [Arguments]  ${filename}  @{locators}
    Capture page screenshot  ${filename}
    Crop page screenshot  ${filename}  @{locators}

Highlight
    [Documentation]  Add highlighting around given locator
    [Arguments]  ${locator}
    ...          ${width}=3
    ...          ${style}=dotted
    ...          ${color}=red

    Update element style  ${locator}  outline  ${width}px ${style} ${color}

Clear highlight
    [Documentation]  Clear highlighting from given locator
    [Arguments]  ${locator}
    Update element style  ${locator}  outline  none
