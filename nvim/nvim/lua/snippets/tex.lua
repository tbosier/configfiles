--~/.config/nvim/lua/snippets/latex.lua

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

return {
  -- Simple Hello Snippet
  s("hello", {
    t({"Hello, World!", ""}),
    i(1, "Your text here"),
    t({"", "$0"}),
  }),

  s("test", {
  t("This is a test snippet"),
  i(0),
  }),
  
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
  t({
    "\\documentclass[12pt]{article}",
    "",
    "% Essential Packages",
    "\\usepackage[utf8]{inputenc}",
    "\\usepackage{amsmath, amssymb}",
    "\\usepackage{geometry}",
    "\\usepackage{fancyhdr}",
    "\\usepackage{titlesec}",
    "\\usepackage{enumitem}",
    "\\usepackage{hyperref}",
    "\\usepackage{graphicx}",
    "\\usepackage{xcolor}",
    "\\usepackage{tcolorbox}",
    "\\usepackage{fontspec}",
    "",
    "% Page Layout",
    "\\geometry{",
    "    top=1in,",
    "    bottom=1in,",
    "    left=1in,",
    "    right=1in",
    "}",
    "",
    "% Header and Footer",
    "\\pagestyle{fancy}",
    "\\fancyhf{}",
    "\\fancyhead[L]{\\textit{"
  }),
  i(1, "Header Left"),
  t({
    "}}",
    "\\fancyhead[R]{\\thepage}",
    "\\fancyfoot[C]{"
  }),
  i(2, "Footer Center"),
  t({
    "}",
    "",
    "% Section Title Formatting",
    "\\titleformat{\\section}",
    "  {\\Large\\bfseries}{\\thesection}{1em}{}",
    "",
    "\\titleformat{\\subsection}",
    "  {\\large\\bfseries}{\\thesubsection}{1em}{}",
    "",
    "% List Formatting",
    "\\setlist[itemize]{noitemsep, topsep=0pt}",
    "",
    "% Hyperlink Colors",
    "\\hypersetup{",
    "    colorlinks=true,",
    "    linkcolor=blue,",
    "    urlcolor=blue,",
    "    citecolor=blue",
    "}",
    "",
    "\\begin{document}",
    "",
    "\\begin{center}",
    "    {\\LARGE \\textbf{"
  }),
  i(3, "Document Title"),
  t({
    "}} \\\\",
    "    \\vspace{0.5em}",
    "    {\\large "
  }),
  i(4, "Author and Affiliation"),
  t({
    " \\\\",
    "    Assistant Professor \\\\",
    "    Stewart School of Industrial and Systems Engineering}",
    "\\end{center}",
    "",
    "\\vspace{1em}",
    "",
    "\\section*{Learning Objectives for this Lesson}",
    "\\begin{itemize}",
    "    \\item "
  }),
  i(5, "Objective 1"),
  t({""}),
  t({
    "    \\item "
  }),
  i(6, "Objective 2"),
  t({
    "\\end{itemize}",
    "",
    "\\section*{We Learned}",
    "\\begin{itemize}",
    "    \\item "
  }),
  i(7, "Takeaway 1"),
  t({
    "    \\item "
  }),
  i(8, "Takeaway 2"),
  t({
    "\\end{itemize}",
    "",
    "\\end{document}"
  }),
  i(0),
}),
}
