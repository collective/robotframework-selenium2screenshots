Robot Framework Selenium2Screenshots Library
============================================

Usage
-----

Include keywords with::

    Library  Selenium2Screenshots

.. note::

   Currently, RIDE is unable to find keywords provided by this library when
   this library is imported with ``Library  Selenium2Screenshots``. This can be
   fixed by requiring the library with
   ``Resource Selenium2Screenshots/keywords.robot``.

   (Currently all keywords are written as user keywords, but later they may be
   refactored into Python-keywords. If this happens, there will be backwards
   compatible wrappers available at ``keywords.robot``.)

Keywords
--------

.. robot_keywords::
   :source: Selenium2Screenshots:keywords.robot

Source
------

.. robot_source::
   :source: Selenium2Screenshots:keywords.robot
