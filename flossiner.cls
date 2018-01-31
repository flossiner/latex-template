\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{flossiner}[2018/01/14 v0.0.2beta412 FLOSSinER Journal of the Free Libre and Open Source Software in Educational Research LaTeX article class]

%Palatino font
\RequirePackage{mathpazo}   
%\RequirePackage{tgpagella}

%Font resizing engine
\RequirePackage{anyfontsize}

%Logic engine
\RequirePackage{ifthen}

%Inheritance from 'article' base class
\LoadClass[a4paper,12pt]{article}
\sloppy 

%Margins
\RequirePackage[
left=2.5cm,
top=1.5cm,
bottom=3cm,
right=2.5cm,
nohead,
nomarginpar
]{geometry}

%Bibliography
\RequirePackage{apacite}

%Line and paragraph spacing (whole document)
\renewcommand{\baselinestretch}{1.15}
\setlength{\parskip}{1.75ex}
\setlength{\parindent}{0pt}
\setlength{\footskip}{15pt}
\setlength{\headheight}{24pt}
%

%Captions
\RequirePackage{caption}
\captionsetup[table]{%
	labelfont=it,
	labelsep=newline,
	justification=justified,
	singlelinecheck=false,
	position=above,
	skip=0pt,
}

\captionsetup[figure]{%
	labelfont=it,
	labelsep=period,
}

\captionsetup[lstlisting]{%
	labelfont=it,
	labelsep=period,
	justification=justified,
	singlelinecheck=false,
	position=above,
	skip=0pt,
}

%Authoring data
\newtoks\authorrun
\global\authorrun={}
\providecommand{\authorrunning}[1]{\global\authorrun={#1}}

%Headers&Footers
\RequirePackage{fancyhdr}
\RequirePackage{datetime}
\makeatletter
\AtBeginDocument{
	\fancypagestyle{firststyle}{
		\pagestyle{fancyplain}
		\fancyhf{}
		\fancyfoot[R]{\thepage}
	}	
	\pagestyle{fancy}
	\fancyhf{}
	\fancyfoot[R]{\thepage}
	\renewcommand{\headrulewidth}{0pt}
	\renewcommand{\footrulewidth}{0pt}
	\fancyhead[R]{{\itshape\the\authorrun\space}}
	\fancyhead[L]{\mbox{\itshape\the\year, FLOSSinER, \InputIfFileExists{issue.txt}{}{}}}
\makeatother
}

%Graphics
\RequirePackage{graphicx}

%Listing package configuration
\RequirePackage{listings}
\RequirePackage{color}
\definecolor{dkgreen}{rgb}{0,0.6,0}
\definecolor{gray}{rgb}{0.5,0.5,0.5}
\definecolor{mauve}{rgb}{0.58,0,0.82}
\definecolor{lgray}{rgb}{0.9,0.9,0.9}
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
	extendedchars=true,
}

%Web references
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

%Section titles and numbering
\RequirePackage{titlesec}

%---------------------------------------------------------------
%   https://github.com/mava/GitTeX - embedded git version info
%   Configuration: git config alias.tex "log -1 --pretty=format:'\newcommand*{\gitdate}{%ad}%n\newcommand*{\githash}{\texttt{%h}}%n\newcommand*{\gitrefnames}{{\scriptsize\texttt{%d}}}%n'"
%   or in config file:
%   [alias]
%       tex = log -1 --pretty=format:'\newcommand*{\gitdate}{%ad}%n\newcommand*{\githash}{\texttt{%h}}%n\newcommand*{\gitrefnames}{{\scriptsize\texttt{%d}}}%n'

\immediate\write18{git tex > \jobname.gtx}
\InputIfFileExists{\jobname.gtx}{}{}
\providecommand*{\gitdate}{\today}
\providecommand*{\githash}{NO COMMIT HASH DEFINED}
\providecommand*{\gitrefnames}{NO RELEASE NAME SPECIFIED}
%---------------------------------------------------------------

%Section numbers: set off
%\setcounter{secnumdepth}{-1}

%Section style
\titleformat*{\section}{\normalfont\normalsize\bfseries}
\titleformat*{\subsection}{\normalfont\normalsize\bfseries\itshape}
\titleformat*{\subsubsection}{\normalfont\normalsize\itshape}

%Title section
\newcounter{aff}	%Affiliation counter
\setcounter{aff}{1}

\makeatletter
\let\@fnsymbol\@arabic
\makeatother

\renewcommand{\footnotesize}{\scriptsize}

\providecommand{\affiliation}[1]{
	\ifthenelse{\equal{\thepage}{1}}{
		\footnote[\theaff]{#1}
		\stepcounter{aff}
	}{}
}

\makeatletter
\renewcommand{\@maketitle}{
    \begin{tabular}{cc}
        \hline
        \begin{minipage}[c][3.5cm][c]{2.67cm}
        	\includegraphics[
            	width=2.67cm,
            	height=2.59cm
        	]{logo}
        \end{minipage}
        &
        \begin{minipage}[c][3.5cm][c]{12.5cm}
	        \begin{center}
	        	\vspace{4.2mm}
	        	Journal of the Free/Libre and Open Source Software\\
	        	\vspace{3.5mm}
	        	in Educational Research $||$ F\/L\/O\/S\/S\/in\/E\/R\\
	        	\vspace{4.2mm}
	        	\begin{tabular}{lccc}
	        		\InputIfFileExists{issue.txt}{}{(issue number)}, \the\year\hspace{0.5cm}
	        		&
	        		\includegraphics[
	        			width=4.7mm,
	        			height=4.7mm
	        		]{home}\ \href{https://www.flossiner.com/}{flossiner.com}
	        		&
	        		$||$
	        		&
	        		\includegraphics[
	        			width=4.7mm,
	        			height=4.7mm
	        		]{twitter}\ \href{https://twitter.com/flossiner/}{@flossiner.com}
	        	\end{tabular}
        	\end{center}
        \end{minipage}
    \end{tabular}
    \begin{center}
    	{\fontsize{14pt}{0pt}
    		\vspace{0.7cm}
    		\textbf{\@title}
    	}
    	\par\textit{\@author}
    \end{center}
}
\makeatother

%Abstract and keywords
\RequirePackage{tabularx}
\RequirePackage{colortbl}
\RequirePackage{environ}
\makeatletter
\newtoks\@keywords
\global\@keywords={}
\providecommand{\@keywordsname}{\textit{Keywords:}}
\providecommand{\keywords}[1]{\global\@keywords={#1}}
\RenewEnviron{abstract}{
	\thispagestyle{firststyle}
	\fontsize{9pt}{0.6\baselineskip}\selectfont\begin{tabularx}{\textwidth}{|p{11.5cm}|X|}
		\hline
		\cellcolor{lgray}
		\textbf{\abstractname}\linebreak\BODY\linebreak\linebreak\@keywordsname\linebreak\the\@keywords	&
		\InputIfFileExists{remarks.txt}{}{Remarks\linebreak(filled by editor)}\\
		\hline
	\end{tabularx}
}
\makeatother

%-----------------------------------------------------------
