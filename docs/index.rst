Robot Framework Selenium2Screenshots Library
============================================

Usage
-----

Include keywords with::

   Resource  Selenium2Screenshots/keywords.robot

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
   Resource  Selenium2Screenshots/keywords.robot

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

And this is how this would look:

.. image:: robotframework.png
   :width: 600

Keywords
--------

See :download:`Keyword documentation <keywords.html>`.

.. note:: All keywords are written as user keywords, but later they may be
   refactored into Python-keywords. If this happens, there will be backwards
   compatible wrappers available at ``keywords.robot``.

.. robotframework::
   :creates: robotframework.png
