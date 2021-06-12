\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mkessler-script}[2021/03/31 Write up lecture notes as script]

%%%%Options of the package
\newif\ifenglish\englishtrue
\DeclareOption{english}{\englishtrue}
\DeclareOption{german}{\englishfalse}

\newif\ifshowversion\showversiontrue
\DeclareOption{show version}{\showversiontrue}
\DeclareOption{hideversion}{\showversionfalse}

\ProcessOptions\relax


%%%%Define command to set metainformation of document
%Set the course
\def\@course{}%
\DeclareRobustCommand*{\course}[1]{\gdef\@course{#1}}
\def\@lecturer{}%
\def\@lecturertitle{}
\DeclareRobustCommand*{\lecturer}[2][]{
    \gdef\@lecturer{#2}
    \gdef\@lecturertitle{\ifenglish Lecturer\else\ifthenelse{\isempty{#1}}{Dozent}{Dozentin}\fi}{}
}

%Set the assistant
\def\@assistant{}%
\def\@assistantitle{}
\DeclareRobustCommand*{\assistant}[2][]{
    \gdef\@assistant{#2}
    \gdef\@assistanttitle{\ifenglish Assistant\else\ifthenelse{\isempty{#1}}{Assistent}{Assistentin}\fi}
}

%%%%Load base class article
\LoadClass{article}

%%%%Title
%Define layout of title using course, lecturer, assistant and author, and optionally the current time
\RequirePackage{datetime}
\renewcommand\@maketitle{%
  \newpage
  \null
  \vskip 2em%
  \begin{center}%
  \let \footnote \thanks
    {\LARGE \@course \par}%
    \vskip 1.5em%
    {\large
      \lineskip .5em%
      \begin{tabular}[t]{c}%
        \@lecturertitle \\
        {\sc \@lecturer} \\
      \end{tabular}\par
    \vskip 1em%
        \begin{tabular}[t]{c}%
        \@assistanttitle \\
        {\sc \@assistant} \\
        \end{tabular}\par
    \vskip 1em%
        \begin{tabular}[t]{c}%
        \ifenglish Notes\else Mitschrift\fi \\
        {\sc \@author} \\
        \end{tabular}
        \par}%
    \ifshowversion
    \vskip 3em%
        \begin{tabular}[t]{c}%
        {\small Version} \\
        \today\,\currenttime
        \end{tabular}\par
    \fi
    \vskip 4em%
  \end{center}%
  \par
  \vskip 1.5em
}


%%%Document-specific features that are provided

%%%%Management of vocabulary and corresponding index
\RequirePackage{imakeidx}
\makeindex[columns=2, title=\ifenglish Index\else Stichwortverzeichnis\fi, intoc]

%Emphasize \vocabulary
\RequirePackage{xparse}
\RequirePackage{expl3}
\ExplSyntaxOn
\NewDocumentCommand{\vocab}{O{} m}{
    \textbf{\color{blue} #2}
    \ifthenelse{\isempty{#1}}{\index{\text_titlecase_first:n{#2}}}{\index{#1}}
}
\ExplSyntaxOff

%%%%Bibliography management
\RequirePackage[backend=biber,style=alphabetic]{biblatex}
\addbibresource{bibliography.bib}
\addbibresource{images.bib}

%Provide simpler commands to properly print image attributions and literature
\DeclareRobustCommand*{\printimageattributions}{
    \def\imageattributionstitle{\ifenglish Image attributions \else Bildquellen\fi}
    \phantomsection
    \addcontentsline{toc}{section}{\imageattributionstitle}
    \printbibliography[title={\imageattributionstitle}, type=image]
}

\DeclareRobustCommand*{\printliterature}{
    \def\literaturetitle{\ifenglish Literature\else Literatur\fi}
    \phantomsection
    \addcontentsline{toc}{section}{\literaturetitle}
    \printbibliography[title={\literaturetitle}, nottype=image]

}

%%%Hyperref and setup
\RequirePackage{hyperref} % Hyperlinks
\RequirePackage{amsmath} % Cleveref needs this
\RequirePackage{cleveref} % Better referencing
\hypersetup{colorlinks, citecolor=violet, urlcolor=blue!80!black, linkcolor=red!50!black, pdfauthor=\@author, pdftitle=\@course}

%%%The following is based on the repository
% https://github.com/gillescastel/university-setup
% but has been modified for own purposes. The original content is distributed under the following license:

%MIT License

%Copyright (c) 2019 Gilles Castel

%Permission is hereby granted, free of charge, to any person obtaining a copy
%of this software and associated documentation files (the "Software"), to deal
%in the Software without restriction, including without limitation the rights
%to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%copies of the Software, and to permit persons to whom the Software is
%furnished to do so, subject to the following conditions:
%
%The above copyright notice and this permission notice shall be included in all
%copies or substantial portions of the Software.
%
%THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%SOFTWARE.


% Some basic packages
\RequirePackage{url}
\RequirePackage{graphicx}
\RequirePackage{float}

% for wrapping text around figures
\RequirePackage{wrapfig}

%%This option is for now commented out, not sure what it does, but causes errors
%\pdfminorversion=7


% Don't indent paragraphs, leave some space between them
\RequirePackage{parskip}

% Hide page number when page is empty
\RequirePackage{emptypage}

% Put x \to \infty below \lim
\let\svlim\lim\def\lim{\svlim\limits}

%Make implies and impliedby shorter
\let\implies\Rightarrow
\let\impliedby\Leftarrow
\let\iff\Leftrightarrow
\let\epsilon\varepsilon

% Fix some spacing
% http://tex.stackexchange.com/questions/22119/how-can-i-change-the-spacing-before-theorems-with-amsthm
\def\thm@space@setup{%
  \thm@preskip=\parskip \thm@postskip=0pt
}

%%%%%%%Setup of lectures and their summary

%Tocloft package for making a list of lectures
\RequirePackage{tocloft}
%Store name of the summary in a command to use it multiple times
\newcommand\listlecturename{\ifenglish Summary of lectures\else Übersicht der Vorlesungen\fi}
\newlistof{lecture}{lec}{\listlecturename} % Declare new list of lectures
%Settings how to print the summary
\renewcommand{\cftdot}{}
\renewcommand\cftlecturefont{\normalfont\bfseries}
\renewcommand\cftlecturepagefont{\normalfont\bfseries}
\renewcommand\cftlectitlefont{\Large\bfseries}
\renewcommand\cftbeforelectureskip{1em}

%Command to parse the date
\RequirePackage{xifthen}
\def\testdateparts#1{\dateparts#1\relax}
\def\dateparts#1 #2 #3 #4 #5\relax{
    \marginpar{\small\textsf{\mbox{#1 #2 #3 #5}}}
}

%Define the main lecture command to start a new lecture
\def\@lectureprefix{\ifenglish Lecture\else Vorlesung\fi}
\def\@lecture{}%
\newcommand{\lecture}[3][]{
    \refstepcounter{lecture}
    %Store lecture name in the macro \@lecture
    \ifthenelse{\isempty{#3}}{%
    \def\@lecture{\@lectureprefix\, \thelecture}%
    }{%
    \def\@lecture{\@lectureprefix\, \thelecture: #3}%
    }%
    \marginpar{\small\textsf{\parbox{10em}{\@lectureprefix\, \thelecture \\#2}}}
    %Add lecture as an entry to the lectures file
    \addcontentsline{lec}{lecture}{\@lectureprefix\,\thelecture\,(#2)}
    %If key words are provided, add the key words of the lecture below the entry
    \ifthenelse{\isempty{#1}}{}{\addtocontents{lec}{\smallskip\hspace{1.5em}\protect\parbox{\dimexpr\textwidth-\@pnumwidth - 7em}{#1}}}
}



%Provide a command to show the summary of lectures
\DeclareRobustCommand*{\summaryoflectures}{
    \phantomsection
    \addcontentsline{toc}{section}{\listlecturename}
    \thispagestyle{plain}
    \listoflecture
}

%%%% These are the fancy headers
\RequirePackage{fancyhdr}
\pagestyle{fancy}

% LE: left even
% RO: right odd
% CE, CO: center even, center odd
% My name for when I print my lecture notes to use for an open book exam.
% \fancyhead[LE,RO]{Gilles Castel}

\fancyhead[RO,LE]{\@lecture} % Right odd,  Left even
\fancyhead[RE,LO]{}          % Right even, Left odd

\fancyfoot[RO,LE]{\thepage}  % Right odd,  Left even
\fancyfoot[RE,LO]{}          % Right even, Left odd
\fancyfoot[C]{\leftmark}     % Center

\makeatother


%%No fancy headers in the appendix (as there is no lecture)
\let\oldappendix\appendix
\renewcommand\appendix{
    \oldappendix
    \fancyhead[RO,LE]{}
    \renewcommand{\headrulewidth}{0pt}
}

% Todonotes and inline notes in fancy boxes
\RequirePackage{todonotes}

% Figure support as explained in my blog post.
\RequirePackage{import}
\RequirePackage{xifthen}
\RequirePackage{pdfpages}
\RequirePackage{transparent}
\newcommand{\incfig}[1]{%
    \def\svgwidth{\columnwidth}
    \import{./figures/}{#1.pdf_tex}
}

% Fix some stuff
% %http://tex.stackexchange.com/questions/76273/multiple-pdfs-with-page-group-included-in-a-single-page-warning
\pdfsuppresswarningpagegroup=1

