import sys
from setuptools import setup, find_packages


install_requires = [
        "setuptools",
        "robotframework>=3.0.2",
        "robotframework-selenium2library>=3.0.0b1",
    ]


setup(
    name="robotframework-selenium2screenshots",
    version='0.8.0',
    description="Robot Framework keyword library for capturing annotated "
                "screenshots with Selenium2Library",
    long_description=(open("README.rst").read() + "\n" +
                      open("CHANGES.txt").read()),
    # Get more strings from
    # http://pypi.python.org/pypi?%3Aaction=list_classifiers
    classifiers=[
        "Programming Language :: Python",
        "Programming Language :: Python :: 2.7",
        "Programming Language :: Python :: 3.4",
        "Programming Language :: Python :: 3.5",
        "Programming Language :: Python :: 3.6",
    ],
    keywords="",
    author="Asko Soukka",
    author_email="asko.soukka@iki.fi",
    url="https://github.com/datakurre/robotframework-selenium2screenshots/",
    license="GPL",
    packages=find_packages("src", exclude=["ez_setup"]),
    package_dir={"": "src"},
    include_package_data=True,
    zip_safe=False,
    install_requires=install_requires,
    extras_require={"docs": [
        "Sphinx",
        "Pillow",
        "sphinxcontrib-robotframework",
    ], "PIL": ["PIL"], "Pillow": ["Pillow"]},
)
