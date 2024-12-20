-- ~/.config/nvim/lua/snippets/latex.lua

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

return {
  -- Equation Snippet
  s("eq", {
    t({"\\begin{equation}"}),
    t({"  "}),
    i(1, "equation"),
    t({"", "\\end{equation}"}),
    i(0),
  }),

  -- Theorem Snippet
  s("thm", {
    t({"\\begin{theorem}["}),
    i(1, "Title"),
    t({"]", "  "}),
    i(2, "Theorem statement"),
    t({"", "\\end{theorem}"}),
    i(0),
  }),

  -- Lesson Template Snippet
  s("lesson", {
    t({"\\documentclass[12pt]{article}", ""}),
    t({"% Essential Packages"}),
    t({"\\usepackage[utf8]{inputenc}"}),
    t({"\\usepackage{amsmath, amssymb}"}),
    t({"\\usepackage{geometry}"}),
    t({"\\usepackage{fancyhdr}"}),
    t({"\\usepackage{titlesec}"}),
    t({"\\usepackage{enumitem}"}),
    t({"\\usepackage{hyperref}"}),
    t({"\\usepackage{graphicx}"}),
    t({"\\usepackage{xcolor}"}),
    t({"\\usepackage{tcolorbox}"}),
    t({"\\usepackage{fontspec}"}),
    t({""}),

    -- Page Layout
    t({"% Page Layout"}),
    t({"\\geometry{", "    top=1in,", "    bottom=1in,", "    left=1in,", "    right=1in", "}"}),
    t({""}),

    -- Header and Footer
    t({"% Header and Footer"}),
    t({"\\pagestyle{fancy}"}),
    t({"\\fancyhf{}"}),
    t({"\\fancyhead[L]{\\textit{"}),
    i(1, "Header Left"),
    t({"}}"}),
    t({"\\fancyhead[R]{\\thepage}"}),
    t({"\\fancyfoot[C]{"}),
    i(2, "Footer Center"),
    t({"}"}),
    t({""}),

    -- Section Title Formatting
    t({"% Section Title Formatting"}),
    t({"\\titleformat{\\section}", "  {\\Large\\bfseries}{\\thesection}{1em}{}"}),
    t({"", "\\titleformat{\\subsection}", "  {\\large\\bfseries}{\\thesubsection}{1em}{}"}),
    t({""}),

    -- List Formatting
    t({"% List Formatting"}),
    t({"\\setlist[itemize]{noitemsep, topsep=0pt}"}),
    t({""}),

    -- Hyperlink Colors
    t({"% Hyperlink Colors"}),
    t({"\\hypersetup{", "    colorlinks=true,", "    linkcolor=blue,", "    urlcolor=blue,", "    citecolor=blue", "}"}),
    t({""}),

    -- Begin Document
    t({"\\begin{document}", ""}),
    t({"\\begin{center}"}),
    t({"    {\\LARGE \\textbf{"}),
    i(3, "Document Title"),
    t({"}} \\\\"}),
    t({"    \\vspace{0.5em}"}),
    t({"    {\\large "}),
    i(4, "Author and Affiliation"),
    t({" \\\\", "    Assistant Professor \\\\", "    Stewart School of Industrial and Systems Engineering}"}),
    t({"\\end{center}", ""}),
    t({"\\vspace{1em}", ""}),

    -- Learning Objectives
    t({"\\section*{Learning Objectives for this Lesson}"}),
    t({"\\begin{itemize}"}),
    t({"    \\item "}),
    i(5, "Objective 1"),
    t({"    \\item "}),
    i(6, "Objective 2"),
    t({"\\end{itemize}", ""}),

    -- We Learned Section
    t({"\\section*{We Learned}"}),
    t({"\\begin{itemize}"}),
    t({"    \\item "}),
    i(7, "Takeaway 1"),
    t({"    \\item "}),
    i(8, "Takeaway 2"),
    t({"\\end{itemize}"}),
    t({"", "\\end{document}"}),
    t({"$0"}),
  }),
}
