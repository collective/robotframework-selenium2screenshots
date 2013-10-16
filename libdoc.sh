#!/bin/sh
LIBDOC="python -m robot.libdoc -F REST"

$LIBDOC --name="Selenium2Screenshots" Selenium2Screenshots/keywords.robot docs/keywords.html

