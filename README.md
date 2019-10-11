
# Table of Contents

1.  [Introduction](#org8ed233d)
2.  [Publishing](#orgea1308b)



<a id="org8ed233d"></a>

# Introduction

Not yet there!


<a id="orgea1308b"></a>

# Publishing

Combined publishing is carried out using the publishing class `Publisher` printed in [code<sub>main</sub><sub>publisher</sub><sub>main</sub>](#org8a0a596). The `publisher.publish` method carries out the publishing run and returns `True` when all subsequent calls to the publishing scripts have been successful:

    True

    """ Multi-Publishing tools: Publish multiple papers from a single position, supporting
    all 'pandoc' supported formats.
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

