\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{flossiner}[2025/01/14 v1.0.0beta - FLOSS Journal LaTeX research article class - based on distinct FLOSSinER project]

%==============================================================================
% CLASS OPTIONS
%==============================================================================
\newif\if@flossiner@nogit
\@flossiner@nogitfalse

\newif\if@flossiner@strict
\@flossiner@strictfalse

\DeclareOption{nogit}{\@flossiner@nogittrue}
\DeclareOption{strict}{\@flossiner@stricttrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

\ExecuteOptions{twoside,12pt}
\ProcessOptions\relax

%==============================================================================
% BASE CLASS AND PACKAGES
%==============================================================================
\LoadClass[a4paper]{article}

\sloppy 

%Palatino font
\RequirePackage{mathpazo}   

%Font resizing engine
\RequirePackage{anyfontsize}

%Logic engine
\RequirePackage{ifthen}

%Margins
\RequirePackage[
left=2.5cm,
top=1.5cm,
bottom=3cm,
right=2.5cm,
nohead,
nomarginpar
]{geometry}

%Graphics - load early
\RequirePackage{graphicx}

%Listing package configuration
\RequirePackage{listings}
\RequirePackage{color}

%Bibliography
\RequirePackage{apacite}

%Section titles and numbering
\RequirePackage{titlesec}

%Headers&Footers
\RequirePackage{fancyhdr}
\RequirePackage{datetime}

%Abstract environment
\RequirePackage{tabularx}
\RequirePackage{colortbl}
\RequirePackage{environ}

%Web references - loaded near end to avoid conflicts
\RequirePackage{hyperref}
\hypersetup{
	urlcolor=blue,
	linkcolor=black,
	anchorcolor=black,
	citecolor=black,
	filecolor=blue,
	menucolor=blue,
	colorlinks=true
}

%==============================================================================
% CONFIGURABLE DIMENSIONS
%==============================================================================
% Fixed: Define dimensions as length registers for easy customization
\newlength{\flossiner@logowidth}
\newlength{\flossiner@logoheight}
\newlength{\flossiner@titleboxheight}
\newlength{\flossiner@contentwidth}
\newlength{\flossiner@iconsize}

\setlength{\flossiner@logowidth}{2.67cm}
\setlength{\flossiner@logoheight}{2.59cm}
\setlength{\flossiner@titleboxheight}{3.5cm}
\setlength{\flossiner@contentwidth}{12.5cm}
\setlength{\flossiner@iconsize}{4.7mm}

%==============================================================================
% COLOR DEFINITIONS
%==============================================================================
\definecolor{dkgreen}{rgb}{0,0.6,0}
\definecolor{gray}{rgb}{0.5,0.5,0.5}
\definecolor{mauve}{rgb}{0.58,0,0.82}
\definecolor{lgray}{rgb}{0.9,0.9,0.9}

%==============================================================================
% LINE AND PARAGRAPH SPACING
%==============================================================================
\renewcommand{\baselinestretch}{1.15}
\setlength{\parskip}{1.75ex}
\setlength{\parindent}{0pt}
\setlength{\footskip}{15pt}
\setlength{\headheight}{24pt}

%==============================================================================
% CAPTIONS
%==============================================================================
\RequirePackage{caption}
\captionsetup[table]{
	labelfont=it,
	labelsep=newline,
	justification=justified,
	singlelinecheck=false,
	position=above,
	skip=0pt,
}

\captionsetup[figure]{
	labelfont=it,
	labelsep=period,
}

\captionsetup[lstlisting]{
	labelfont=it,
	labelsep=period,
	justification=justified,
	singlelinecheck=false,
	position=above,
	skip=0pt,
}

%==============================================================================
% LISTINGS CONFIGURATION
%==============================================================================
\lstset{
	basicstyle=\ttfamily,
	extendedchars=true,
	numbers=left,
	numberstyle=\color{black}\scriptsize\ttfamily,
	stepnumber=1,
	numbersep=1pt,
	showspaces=false,
	showstringspaces=false,
	backgroundcolor=\color{lgray},
	breaklines=true,
	keywordstyle=\color{blue},
	commentstyle=\color{dkgreen},
	stringstyle=\color{mauve},
	tabsize=4,
}

%==============================================================================
% AUTHORING DATA
%==============================================================================
% Fixed: Use modern LaTeX2e command definition instead of token registers
\makeatletter
\newcommand{\@authorrun}{}
\newcommand{\authorrunning}[1]{\renewcommand{\@authorrun}{#1}}

%==============================================================================
% HEADERS & FOOTERS
%==============================================================================
% Fixed: Proper scope for \makeatletter and \AtBeginDocument
\AtBeginDocument{
	\fancypagestyle{firststyle}{
		\fancyhf{}
		\fancyfoot[R]{\thepage}
		\renewcommand{\headrulewidth}{0pt}
		\renewcommand{\footrulewidth}{0pt}
	}
	\pagestyle{fancy}
	\fancyhf{}
	\fancyfoot[R]{\thepage}
	\renewcommand{\headrulewidth}{0pt}
	\renewcommand{\footrulewidth}{0pt}
	\fancyhead[R]{\itshape\@authorrun\space}
	\fancyhead[L]{\itshape\the\year, FLOSSinER, \InputIfFileExists{issue.txt}{}{Vol.~X, No.~X}}
}
\makeatother

%==============================================================================
% GIT VERSION INTEGRATION
%==============================================================================
% Fixed: Better handling with option to disable and error checking
\makeatletter
\newif\if@flossiner@gitsuccess
\@flossiner@gitsuccessfalse
\if@flossiner@nogit
	% Git integration disabled
	\providecommand*{\gitdate}{\today}
	\providecommand*{\githash}{\texttt{(no git info)}}
	\providecommand*{\gitrefnames}{}
	\ClassInfo{flossiner}{Git integration disabled (nogit option)}
\else
	% Try to get git information
	% Note: Requires --shell-escape compilation flag
	% Use a more robust approach with escaped quotes
	\begingroup
		\catcode`\"=12  % Make " a normal character
		\immediate\write18{git log -1 --date=short --pretty=format:'\@percentchar\@percentchar' > \jobname.gittmp 2>/dev/null && echo '\string\\newcommand*{\string\\gitdate}{'`git log -1 --date=short --pretty=format:\@percentchar ad`'}' > \jobname.gtx && echo '\string\\newcommand*{\string\\githash}{\string\\texttt{'`git log -1 --pretty=format:\@percentchar H`'}}' >> \jobname.gtx && echo '\string\\newcommand*{\string\\gitrefnames}{{\string\\scriptsize\string\\texttt{'`git log -1 --pretty=format:\@percentchar d`'}}}' >> \jobname.gtx || echo '' > \jobname.gtx}
	\endgroup
	
	% Try to input the generated file
	\InputIfFileExists{\jobname.gtx}{
		\ClassInfo{flossiner}{Git integration enabled}
		\@flossiner@gitsuccesstrue
	}{
		% File doesn't exist - shell-escape probably not enabled
		\ClassWarning{flossiner}{
			Git information could not be retrieved.^^J
			Make sure to:^^J
			- Compile with --shell-escape flag^^J
			- Be in a git repository^^J
			- Have git installed^^J
			Use 'nogit' class option to suppress this warning%
		}
	}
	
	% Always provide fallback commands using \providecommand
	% These will only be defined if the git commands above failed
	\providecommand*{\gitdate}{\today}
	\providecommand*{\githash}{\texttt{(no commit)}}
	\providecommand*{\gitrefnames}{}
\fi
\makeatother

%==============================================================================
% SECTION FORMATTING
%==============================================================================
\titleformat*{\section}{\normalfont\normalsize\bfseries}
\titleformat*{\subsection}{\normalfont\normalsize\bfseries\itshape}
\titleformat*{\subsubsection}{\normalfont\normalsize\itshape}

%==============================================================================
% AFFILIATIONS AND FOOTNOTES
%==============================================================================
% Fixed: Better handling of affiliations without breaking footnotesize globally
\makeatletter

\newcounter{aff}
\setcounter{aff}{1}

% Fixed: Change footnote symbols to numbers only for affiliations
% Store original definition
\let\flossiner@orig@fnsymbol\@fnsymbol
\let\@fnsymbol\@arabic

% Fixed: Create a special size for affiliations instead of redefining \footnotesize
\newcommand{\affiliationfontsize}{\scriptsize}

% Modified footnote command for affiliations
\renewcommand{\footnotesize}{\affiliationfontsize}

\providecommand{\affiliation}[1]{
	\ifthenelse{\equal{\thepage}{1}}{
		\footnote[\theaff]{#1}
		\stepcounter{aff}
	}{
		\if@flossiner@strict
			\ClassError{flossiner}{Affiliation command used outside title page}{Affiliations should only be used in the title section on page 1}
		\else
			\ClassWarning{flossiner}{Affiliation command used on page \thepage, ignored}%
		\fi
	}
}

%==============================================================================
% TITLE SECTION
%==============================================================================
\renewcommand{\@maketitle}{
    \begin{tabular}{cc}
        \hline
        \begin{minipage}[c][\flossiner@titleboxheight][c]{\flossiner@logowidth}
        	% Fixed: Better error handling for missing logo
        	\IfFileExists{logo.pdf}{%
        		\includegraphics[width=\flossiner@logowidth,height=\flossiner@logoheight]{logo.pdf}%
        	}{
        		\IfFileExists{logo.png}{%
        			\includegraphics[width=\flossiner@logowidth,height=\flossiner@logoheight]{logo.png}%
        		}{
        			\ClassWarning{flossiner}{Logo file not found. Looking for logo.pdf or logo.png}%
        			\fbox{\parbox{\flossiner@logowidth}{\centering\vspace{1cm}LOGO\\MISSING\vspace{1cm}}}%
        		}
        	}
        \end{minipage}
        &
        \begin{minipage}[c][\flossiner@titleboxheight][c]{\flossiner@contentwidth}
	        \begin{center}
	        	\vspace{4.2mm}
	        	Journal of the Free/Libre and Open Source Software\\
	        	\vspace{3.5mm}
	        	in Educational Research $||$ F\/L\/O\/S\/S\/in\/E\/R\\
	        	\vspace{4.2mm}
	        	\begin{tabular}{lccc}
	        		\InputIfFileExists{issue.txt}{}{Vol.~X, No.~X}, \the\year\hspace{0.5cm}
	        		&
	        		% Fixed: Better handling for missing icons
	        		\IfFileExists{home.pdf}{
	        			\includegraphics[width=\flossiner@iconsize,height=\flossiner@iconsize]{home.pdf}
	        		}{
	        		    \IfFileExists{home.png}{
	        			    \includegraphics[width=\flossiner@iconsize,height=\flossiner@iconsize]{home.png}
	        		    }{\raisebox{-0.2ex}{\scriptsize[home]}}
	        		}
	        		\ \href{https://www.flossiner.com/}{flossiner.com}
	        		&
	        		$||$
	        		&
	        		\IfFileExists{twitter.pdf}{
	        			\includegraphics[width=\flossiner@iconsize,height=\flossiner@iconsize]{twitter.pdf}
	        		}{
	        		    \IfFileExists{twitter.png}{
	        			    \includegraphics[width=\flossiner@iconsize,height=\flossiner@iconsize]{twitter.png}
	        		    }{\raisebox{-0.2ex}{\scriptsize[X]}}
	        		}
	        		\ \href{https://twitter.com/flossiner/}{@flossiner}
	        	\end{tabular}
        	\end{center}
        \end{minipage}
    \end{tabular}
    \begin{center}
    	\vspace{0.7cm}
    	{\fontsize{14pt}{16.8pt}\selectfont\textbf{\@title}\par}
    	\vspace{0.3cm}
    	{\normalsize\itshape\@author\par}
    \end{center}
}

%==============================================================================
% ABSTRACT AND KEYWORDS
%==============================================================================
\newcommand{\@keywords}{}
\providecommand{\@keywordsname}{\textit{Keywords:}}
\providecommand{\keywords}[1]{\renewcommand{\@keywords}{#1}}

% Fixed: Proper font size calculation and scoping
\RenewEnviron{abstract}{
	\thispagestyle{firststyle}
	\begingroup
		% Fixed: Use proper baseline skip (1.2 * font size)
		\fontsize{9pt}{10.8pt}\selectfont
		\begin{tabularx}{\textwidth}{|p{11.5cm}|X|}
			\hline
			\cellcolor{lgray}
			\textbf{\abstractname}\newline
			\BODY\newline\newline
			\@keywordsname\newline
			\@keywords &
			\InputIfFileExists{remarks.txt}{Remarks\newline(filled by editor)}{%
				Remarks\newline(filled by editor)}\\
			\hline
		\end{tabularx}
	\endgroup
}

\makeatother

%==============================================================================
% VALIDATION AND WARNINGS
%==============================================================================
\makeatletter

% Counter for tracking issues
\newcount\@flossiner@issuecount
\@flossiner@issuecount=0

\AtEndDocument{
	\typeout{}
	\typeout{========================================}
	\typeout{FLOSSinER Document Compilation Summary}
	\typeout{========================================}
	
	% Check and report git status
	\if@flossiner@nogit
		\typeout{Git Integration: DISABLED (nogit option)}
	\else
		\if@flossiner@gitsuccess
			\typeout{Git Integration: SUCCESS}
			\typeout{  - Commit hash: \meaning\githash}
			\typeout{  - Commit date: \meaning\gitdate}
		\else
			\typeout{Git Integration: FAILED}
			\typeout{  - Using fallback values}
			\advance\@flossiner@issuecount by 1
		\fi
	\fi
	
	\typeout{}
	\typeout{Metadata Status:}
	
	% Check running author
	\ifx\@authorrun\@empty
		\typeout{  - Running Author: MISSING}
		\ClassWarning{flossiner}{No running author defined. Use \string\authorrunning{Author(s)} in preamble}%
		\advance\@flossiner@issuecount by 1
	\else
		\typeout{  - Running Author: OK}
	\fi
	
	% Check keywords
	\ifx\@keywords\@empty
		\typeout{  - Keywords: MISSING}
		\ClassWarning{flossiner}{No keywords defined. Use \string\keywords{keyword1, keyword2, ...} in preamble}%
		\advance\@flossiner@issuecount by 1
	\else
		\typeout{  - Keywords: OK}
	\fi
	
	% Check for required graphics files
	\typeout{}
	\typeout{Graphics Files:}
	\IfFileExists{logo.pdf}{%
		\typeout{  - logo.pdf: FOUND}
	}{
		\IfFileExists{logo.png}{%
			\typeout{  - logo.png: FOUND}
		}{
			\typeout{  - logo: MISSING (using placeholder)}
			\advance\@flossiner@issuecount by 1
		}
	}
	
	\IfFileExists{home.pdf}{%
		\typeout{  - home icon: FOUND}
	}{
		\IfFileExists{home.png}{%
			\typeout{  - home icon: FOUND}
		}{
			\typeout{  - home icon: MISSING (using text fallback)}
		}
	}
	
	\IfFileExists{twitter.pdf}{%
		\typeout{  - twitter icon: FOUND}
	}{%
		\IfFileExists{twitter.png}{%
			\typeout{  - twitter icon: FOUND}
		}{%
			\typeout{  - twitter icon: MISSING (using text fallback)}
		}%
	}%
	
	% Check for issue file
	\typeout{}
	\IfFileExists{issue.txt}{%
		\typeout{Issue Number: FOUND (issue.txt)}
	}{
		\typeout{Issue Number: MISSING (using placeholder)}
		\typeout{  Create issue.txt with content like: Vol.~1, No.~1}
		\advance\@flossiner@issuecount by 1
	}
	
	% Final summary
	\typeout{}
	\typeout{========================================}
	\ifnum\@flossiner@issuecount=0
		\typeout{Status: ALL CHECKS PASSED}
		\typeout{Document is ready for publication}
	\else
		\ifnum\@flossiner@issuecount=1
			\typeout{Status: 1 issue found (see above)}
		\else
			\typeout{Status: \number\@flossiner@issuecount\space issues found (see above)}
		\fi
		\typeout{Please address the issues before final submission}
	\fi
	\typeout{========================================}
	\typeout{}
}
\makeatother

\endinput

