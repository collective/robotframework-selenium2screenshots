*** Settings ***

Documentation  This library expects jQuery to be found from the tested page.

Library  String
Library  Collections
Library  Selenium2Library
Library  Selenium2Screenshots.Image

*** Variables ***

${CROP_MARGIN} =  10

*** Keywords ***

Normalize annotation locator
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
    [Arguments]  ${locator}
    ...          ${size}=20  ${display}=block
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
    ...            'border-radius': (${size} / 2).toString() + 'px',
    ...            'top': (
    ...                offset.top + height / 2 - ${size} / 2
    ...            ).toString() + 'px',
    ...            'left': (
    ...                offset.left + width / 2 - ${size} / 2
    ...            ).toString() + 'px',
    ...            'z-index': '9999'
    ...        });
    ...        jQuery('body').append(annotation);
    ...        return id;
    ...    })();
    Should match regexp  ${id}  ^robot-.*
    ...                  msg=${selector} was not found and no dot was created
    [return]  ${id}

Add dot
    [Arguments]  ${locator}  ${text}=${EMPTY}
    ...          ${size}=20
    ...          ${background}=#fcf0ad
    ...          ${color}=black
    ...          ${display}=block
    ${id} =  Add pointer  ${locator}  size=${size}  display=none
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

Remove element
    [Arguments]  ${id}
    Execute Javascript
    ...    return (function(){
    ...        jQuery('#${id}').remove();
    ...        return true;
    ...    })();

Remove elements
    [Arguments]  @{ids}
    :FOR  ${id}  IN  @{ids}
    \  Remove element  ${id}

Update element style
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
    [Arguments]  ${filename}  @{locators}
    Capture page screenshot  ${filename}
    Crop page screenshot  ${filename}  @{locators}
