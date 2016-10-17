import sys
from setuptools import setup, find_packages

PY3 = sys.version_info[0] == 3

install_requires = [
        "setuptools",
        "robotframework-selenium2library",
    ]

if PY3:
    install_requires.append('robotframework-python3 >= 2.6.0')
else:
    install_requires.append('robotframework >= 2.6.0')

setup(
    name="robotframework-selenium2screenshots",
    version='0.7.1',
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
