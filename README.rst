WAVE-library for Robot Framework
================================

WAVE is an accessibility analyzing service and Firefox add-on created by
WebAIM. This library provides a few Robot Framework resources for executing
automated analyzes with the Firefox add-on.

(This package includes a Firefox profile with The WAVE Toolbar extension
pre-installed. The WAVE toolbar, its interface elements, design elements,
functionality, and underlying code are (c) WebAIM.)


Installation
------------

::

    $ pip install robotframework-wavelibrary


Example test
------------

::

    *** Settings ***

    Library  WAVELibrary

    Suite setup  Open WAVE browser
    Suite teardown  Close all browsers

    *** Test Cases ***

    Test single page
        [Documentation]  Single page test could interact with the target
        ...              app as much as required and end with triggering
        ...              the accessibility scan.
        Go to  http://www.plone.org/
        Check accessibility errors

    Test multiple pages
        [Documentation]  Template based test can, for example, take a list
        ...              of URLs and perform accessibility scan for all
        ...              of them. While regular test would stop for the
        ...              first failure, template based test will just jump
        ...              to the next URL (but all failures will be reported).
        [Template]  Check URL for accessibility errors
        http://www.plone.org/
        http://www.drupal.org/
        http://www.joomla.org/
        http://www.wordpress.org/


Running
-------

::

    $ pybot demo.robot

`Read the docs for more detailed information. <https://robot-framework-wave-library.readthedocs.org/>`_
