Robot Framework Selenium2Screenshots Library
============================================

Usage
-----

Include keywords with::

    Library  Selenium2Screenshots

.. note::

   This package implicitly requires PIL (Python Imaging Library), which must
   be installed to use this package. This does not explicitly require PIL to
   allow you to select between PIL and Pillow.

Example
-------

This is how this should work:

.. code:: robotframework

   *** Settings ***

   Library  Selenium2Library
   Library  Selenium2Screenshots

   Suite Teardown  Close all browsers

   *** Test Cases ***

   Take an annotated screenshot of RobotFramework.org
       Open browser  http://robotframework.org/
       Update element style  header  margin-top  1em
       Update element style  header h1  outline  3px dotted red
       ${note1} =  Add pointy note
       ...    header
       ...    This Robot Framework stuff is very very cool!
       ...    width=200  position=bottom
       Capture and crop page screenshot  robotframework.png
       ...    header  ${note1}

And this is this would look:

.. image:: robotframework.png
   :width: 600

Keywords
--------

.. robot_keywords::
   :source: Selenium2Screenshots:keywords.robot

Source
------

.. robot_source::
   :source: Selenium2Screenshots:keywords.robot

Notes
-----

All keywords are written as user keywords, but later they may be
refactored into Python-keywords. If this happens, there will be backwards
compatible wrappers available at ``keywords.robot``.

Currently, RIDE is unable to find keywords provided by this library when this
library is imported with ``Library  Selenium2Screenshots``. This can be fixed
by requiring the library with ``Resource Selenium2Screenshots/keywords.robot``.

.. robotframework::
   :creates: robotframework.png
