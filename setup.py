from setuptools import setup, find_packages

setup(
    name="robotframework-selenium2screenshots",
    version='0.2.1',
    description="Robot Framework keyword library for capturing annotated "
                "screenshots with Selenium2Library",
    long_description=(open("README.rst").read() + "\n" +
                      open("CHANGES.txt").read()),
    # Get more strings from
    # http://pypi.python.org/pypi?%3Aaction=list_classifiers
    classifiers=[
        "Programming Language :: Python",
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
    install_requires=[
        "setuptools",
        "robotframework",
        "robotframework-selenium2library",
    ],
    extras_require={"docs": [
        "Sphinx",
        "Pillow",
        "sphinxcontrib-robotdoc>=0.5.1",
        "sphinxcontrib-robotframework",
    ], "PIL": ["PIL"], "Pillow": ["Pillow"]},
)
