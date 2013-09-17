# -*- coding: utf-8 -*-
import os.path

from robot.libraries.BuiltIn import BuiltIn


class Selenium2Screenshots(object):
    """This library provides a few Robot Framework resources for annotating
    and cropping screenshots taken with Selenium2Library.

    """
    def __init__(self):
        self.import_Selenium2Screenshots_resources()

    def import_Selenium2Screenshots_resources(self):
        """Import Selenium2Screenshots user keywords.
        """
        BuiltIn().import_resource('Selenium2Screenshots/keywords.robot')


class Image(object):

    def crop_image(self, output_dir, filename, left, top, width, height):
        """Crop the saved image with given filename for the given dimensions.
        """
        from PIL import Image

        img = Image.open(os.path.join(output_dir, filename))
        box = (int(left), int(top), int(left + width), int(top + height))

        area = img.crop(box)

        with open(os.path.join(output_dir, filename), 'wb') as output:
            area.save(output, 'png')
