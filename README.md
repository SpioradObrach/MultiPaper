
# Table of Contents

1.  [Introduction](#orgba55434)
2.  [Publishing](#org17e4749)
3.  [Pandoc](#org43e9831)
4.  [Appendix](#org57d9901)



<a id="orgba55434"></a>

# Introduction

This framework is a simple Pandoc-based multi-document conversion setup: Multiple papers can be published from a single calling point. 

Two exemplary paper drafts are provided in `org`<sup><a id="fnr.1" class="footref" href="#fn.1">1</a></sup> and `markdown`<sup><a id="fnr.2" class="footref" href="#fn.2">2</a></sup> format and published to `PDF`, using the `IEEEtran` LaTeX class as an exemplary publishing format.


<a id="org17e4749"></a>

# Publishing

Combined publishing is carried out using the publishing class `Publisher` shown in the code in the [Appendix](#org57d9901) directory. The `publisher.publish` method carries out the publishing run and returns `True` when all subsequent calls to the publishing scripts have been successful:

    True

Which papers are to be published can be specified by passing a list of paper directories to the argument `papers`, for example: 

    publisher = Publisher(papers=['paperA'])
    publisher.publish()

Then, only `paperA` is published.

All this python script does is to enter subsequent paper directories and call the `publish.sh` scripts therein. Notice that this currently limits the framework to work on unix machines. Adding OS-sensitivity and `.bat` scripts alongside or some similar solution makes the framework platform-insensitive.

In the `publish.sh` scripts, the author of the paper specifies Pandoc-instructions for the Pandoc translation run. Meta-data &#x2014; such as the specification of the goal LaTeX class to be used &#x2014; can be specified within the markup documents themselves. In *paperB*, this meta-data is specified within a `yaml` header, an excerpt from this looks like:

    documentclass: IEEEtran
    classoption:
    - twocolumn
    colorlinks: true
    linkcolor: blue
    bibliography: './references.bib'

Here, the LaTeX class is specified, alongside class-specific options, link options and a link to the bibliography file.


<a id="org43e9831"></a>

# Pandoc

Pandoc<sup><a id="fnr.3" class="footref" href="#fn.3">3</a></sup> is "a free and open source document converter"<sup><a id="fnr.4" class="footref" href="#fn.4">4</a></sup> and can be used to translate within different publication formats. In the two exemplary publication templates *paperA* and *paperB*, *org* and *markdown* formats are used to publish to the IEEE latex template using the default Pandoc latex template. This latex template which can be found alongside a default Pandoc installation is also available in the `templates` directory.

Pandoc translates the provided source files


<a id="org57d9901"></a>

# Appendix

    """ Multi-Publishing tools: Publish multiple papers from a single position, supporting
    all 'Pandoc' supported formats.
    """
    import os, subprocess, sys
    
    
    class Publisher:
        """ The main publishing method collection.
        """
        # List of excluded directories
        exclude = ['.git', 'templates']
        # Default publishing script label
        defaults = {'scripts': 'publish.sh'}
    
        def __init__(self, papers='all', verbose=True):
            """
            Args:
                papers (str/list): Defaults to 'all', then all papers are published. When a
                    list is given, the papers listed in `papers` are treated.
                verbose (bool): Flag indicating whether verbose information is to be provided
                    during a publishing-run.
            """
            # Publisher home directory
            self.home = os.getcwd()
            # List of papers to-be treated
            self.papers = self.select(papers)
            # Flag indicating whether verbose output is to be generated
            self.verbose = verbose
    
        def select(self, papers):
            """ Select papers to be treated.
    
            Args:
                papers (str/list): Defaults to 'all', then all papers are published. When a
                    list is given, the papers listed in `papers` are treated.
    
            Returns:
                papers (list): List of paper directories to be treated.
            """
            if type(papers) is str:
                # TODO Exclude unwanted directories
                papers = []
                for directory in next(os.walk('.'))[1]:
                    if directory not in Publisher.exclude:
                        papers.append(directory)
            return papers
    
        def publish(self):
            """ Run the publishing pipeline: Subsequent paper folders are entered and the
            corresponding publishing scripts are called therein. Publishing script labels
            are specified within `Publisher.defaults` under the entry `scripts`.
            Prints verbose output when the corresponding flag `verbose` is set to `True`.
    
            Returns:
                success (bool): Flag indicating whether all paper calls have been successful.
            """
            success = []
            for paper in self.papers:
                if self.verbose:
                    print(f'Publishing paper {paper}')
                try:
                    os.chdir(self.home)
                    directory = os.path.join(os.getcwd(), paper)
                    os.chdir(directory)
                    flag = subprocess.call(
                        [os.path.join(directory, Publisher.defaults['scripts'])])
                    success.append(True)
                except FileNotFoundError:
                    success.append(False)
            if self.verbose:
                successes = sum(success)
                print(f'Finished publishing of `{successes}` papers.')
    
            return any(success)


# Footnotes

<sup><a id="fn.1" href="#fnr.1">1</a></sup> <https://en.wikipedia.org/wiki/Org_mode>

<sup><a id="fn.2" href="#fnr.2">2</a></sup> <https://en.wikipedia.org/wiki/Markdown>

<sup><a id="fn.3" href="#fnr.3">3</a></sup> <https://Pandoc.org/org.html>

<sup><a id="fn.4" href="#fnr.4">4</a></sup> <https://en.wikipedia.org/wiki/Pandoc>
