class UserTex


  def initialize(userid=0)
	@userid = userid
    @lastQ = (Time.now.strftime("%m").to_i-1)/3
    @prolog_quarter_text = @prolog_annual_text if @lastQ == 0
    @lastQ = 4 if @lastQ == 0
    @fileone = File.new("#{@userid}singlepage.tex", "w")
    @filetwo = File.new("#{@userid}multipage.tex", "w")
    @whichfile = @fileone

    @gtotal = 0.00
    @ototal       = 0.00
    @counterlines = [0, 0, 0, 0]
    @prolog_one = <<'END_TEXT'
\documentclass[oneside]{letter}
\usepackage{xunicode}
\usepackage{fontspec}
\newcommand\ScriptFont{Zapfino}
\pagestyle{headings}
\setlength{\topmargin}{0.0in}
\setlength{\headheight}{0.5in}
\setlength{\headsep}{0.25in}
\setlength{\textheight}{9.25in}
\setlength{\textwidth}{6.5in}
\setlength{\hoffset}{-0.75in}
\setlength{\voffset}{-0.5in}
\newcounter{linecount}
\newcommand{\churchaddress}{\framebox[4.25in][s]{
\begin{minipage}{4.1275in}\begin{center}
\setcounter{linecount}{\arabic{pagelines}}
{\huge Nashua Baptist Church}\\
{\large 555 Broad Street, Nashua, NH 03063 Tel: 603-889-4020}
\end{center}\end{minipage}}
\vspace*{0.1in}}
\renewcommand{\name}{NAME}
\newcommand{\totalbreak}{}
\newcommand{\breakneeded}{}
\newcommand{\recipient}{}
\newcommand{\uAddress}{ADDRESS}
\newcommand{\asep}{\\\ \\ }
\newcommand{\headline}{\textbf{\hspace*{0.28in}Date\hspace*{0.28in}}
	& \textbf{\em Amount\em}
	& \textbf{\hspace*{0.28in}Date\hspace*{0.28in}}
	& \textbf{\hspace*{0.2in}Designated\hspace*{0.2in}}
	& \textbf{\hspace*{0.2in}Amount\hspace*{0.2in}}
	& \textbf{YTD Total}}
\newcommand{\checklines}{
\ifthenelse{\arabic{linecount} > 30}
{\setcounter{linecount}{0}\anotherhead}
{\stepcounter{linecount}} \\ \hline \hline}
\newcommand{\anotherhead}{ \\ \hline \hline

\tablebot
\newpage
\tabletop\headline}
\newcommand{\tableline}[5]{ \hline \stepcounter{linecount}#1 & \em#2 & #3 & #4 & \em#5 & \\ \hline\hline }
\newcommand{\quarterline}[4]{ \hline \hline & \em\$#1 & \em#2 Quarter &  & \em\$#3 & \em\$#4 \checklines}
\newcommand{\halfline}[4]{ \hline \hline & \stepcounter{linecount} \em\$#1 & \em#2 Quarter &  & \em\$#3 & \em\$#4 \checklines}
\newcommand{\fourthline}[4]{ \hline \hline & \em\$#1 & \em#2 Quarter &  & \em\$#3 & \em\$#4 \checklines}
\newcommand{\totalline}[3]{ \hline \hline
 \em General Total & \textbf{\em\$#1} &  & \em Designated Total & \em\$#2 & \textbf{\em\$#3}}
\newcommand{\pledge}[2]{\em\Large Your ``Forward in Faith'' pledge was: \$#1 per #2}
\newcommand{\totpledge}[1]{\em\Large Your ``Forward in Faith'' pledge was: \$#1}
\newcommand{\nopledge}{{\em\Large We haven't received your ``Forward in Faith'' pledge yet.}
 \\ If you wish to do so, please contact Charlie Carlin for further information.}
\newcommand{\tabletop}{\begin{tabular}{||c|r||c|c|r||r||} \hline\hline}
\newcommand{\tablebot}{\end{tabular}}
%\newcommand{\recipient}{}
\newcommand{\family}[7]{
\renewcommand{\name}{#1}
\renewcommand{\uAddress}{#1\\#2 #3\\#4, #5 #6 \asep #7}
}
%\newcommand{\family}[7]{\name{#1}\address{#2 #3\\#4, #5 #6 \asep #7}}
\newcommand{\leadtext}{\thispagestyle{empty}
\begin{letter}\name{\recipient}{\begin{center}
\churchaddress\
\underline{\textbf{Last year's contributions. Created on \today}}%
\\
{\uAddress}
\end{center}}
%\vspace*{.5in}%\hspace*{0.5in}\parbox{.5in}{\recipient}
%\clearpage
%\address{Nashua Baptist Church\\555 Broad Street\\Nashua, NH 03062}
%\renewcommand{\recipient}{\name}
\signature{}

{\small For the calendar year
END_TEXT

    @prolog_annual_text = <<'END_TEXT'
our records indicate that you made the following cash contributions.
Should you have any questions about any amount reported or not reported on this statement,
please notify the church financial secretary, Margaret Surtees, within 90 days of the
date of this statement.
Statements that are not questioned within 90 days will be assumed to be accurate,
and any supporting documentation (such as offering envelopes) retained by the church
may be discarded.
{\em No goods or services were provided to you by the church in connection
with any contribution, or their value was insignificant, or consisted entirely
of intangible religious benefits.}}

END_TEXT

    @prolog_quarter_text = <<'END_TEXT'
our records indicate that you made the following cash contributions.
Should you have any questions about any amount reported or not reported on this statement,
please notify the church financial secretary, Margaret Surtees, within 90 days of the
date of this statement.
Statements that are not questioned within 90 days will be assumed to be accurate,
and any supporting documentation (such as offering envelopes) retained by the church
may be discarded.
{\em No goods or services were provided to you by the church in connection
with any contribution, or their value was insignificant, or consisted entirely
of intangible religious benefits.}}
END_TEXT

    @prolog_last = <<'END_TEXT'
\begin{center}\tabletop

\headline \\ \hline \hline}

\newcommand{\trailingtext}{\\ \hline \hline
\tablebot\end{center}

%%\vfill
\hfill
\begin{minipage}{2.38in}
\closing{Thank you for your support,{\fontspec{\ScriptFont}
\vspace*{.25in}

Margaret M. Surtees}
Margaret Surtees\\
Financial Secretary}
\end{minipage}\vfill
\ifthenelse{\value{page} > 2}
{\newpage
\begin{center}
\
\vfill(This page intentially left blank)
\
\vfill
\end{center}}
{\  }
\end{letter}
}

%\begin{document}
\usepackage{ifthen}
\newcounter{pagelines}
\setcounter{pagelines}
END_TEXT

  end

  def getmacro(m)
    "\\#{m}"
  end

  def printmacro(m)
    @whichfile.print getmacro(m)
  end

  def printparam(s)
    @whichfile.print "{#{s}}"
  end

  def printfloat(f)
    printparam(sprintf("%.2f", f))
  end

  def printdollar(f)
    printparam(getmacro('$') << sprintf("%.2f", f))
  end

  def printprolog(whichfile)
    whichfile.print @prolog_one
    whichfile.print " #{LASTYEAR}, "
    whichfile.print @prolog_quarter_text
    whichfile.print "\n"
    whichfile.print @prolog_last
  end

  def checkaddr(addr)
    if (addr.nil?) then
      printparam('??')
    else
      printparam(addr)
    end
  end

  def countlines(g, o, q)
    count = 0
    while (count < g.length) do
      @counterlines[q-1] += 1
      count              += 1
    end
    #    if ((q == 2) || (q == 4)) then
    #        puts "C-Lines = #{@counterlines[0]} + #{@counterlines[1]} + #{@counterlines[2]} + #{@counterlines[3]}"
    #        @counterlines = [0, 0, 0, 0] if(q==4)
    #    end
  end

  def processLines(user, quarter)
    general = []
    others  = []
    allD    = Donation.find :all, :conditions => "user_id = #{user.id}"
    allD.each { |d|
      next unless (d.weekdate.quarter == quarter)
      if (d.budget_id == 1) then
        general << d
      else
        others << d
      end
    }
    while (general.length > others.length) do
      others << nil
    end
    while (others.length > general.length) do
      general << nil
    end
    countlines(general, others, quarter)
  end

  def processtable(g, o, q)
    totalg = 0.00
    totalo = 0.00
    count  = 0
    while (count < g.length) do
      unless (g[count].nil?) then
        printmacro('tableline')
        printparam(g[count].weekdate.date_string)
        printdollar(g[count].amount)
        totalg += g[count].amount
      else
        printmacro('tableline')
        printparam('')
        printparam('')
      end
      unless (o[count].nil?) then
        printparam(o[count].weekdate.date_string)
        printparam(o[count].budget.description)
        printdollar(o[count].amount)
        totalo += o[count].amount
      else
        printparam('')
        printparam('')
        printparam('')
      end
      @whichfile.print "\n"
      count += 1
    end
    if ((q == 2) || (q == 4)) then
      if (q == 4) then
        printmacro('fourthline')
      else
        printmacro('halfline')
      end
    else
      printmacro('quarterline')
    end
    printfloat(totalg)
    printparam(%w(First Second Third Fourth)[q - 1])
    printfloat(totalo)
    printfloat(totalg + totalo)
    @whichfile.print "\n"
    @gtotal += totalg
    @ototal += totalo
  end

  def processQuarter(user, quarter)
    general = []
    others  = []
    allD    = Donation.find :all, :conditions => "user_id = #{user.id}"
    allD.each { |d|
      next unless (d.weekdate.quarter == quarter)
      if (d.budget_id == 1) then
        general << d
      else
        others << d
      end
    }
    while (general.length > others.length) do
      others << nil
    end
    while (others.length > general.length) do
      general << nil
    end
    processtable(general, others, quarter)
  end

  def processUser(user)
    @counterlines = [0, 0, 0, 0]
    q             = 0
    while ((q+=1) <= @lastQ) do
      processLines(user, q)
    end
    totallines = @counterlines[0] + @counterlines[1] + @counterlines[2] + @counterlines[3]
    if (totallines < 15) then
      @whichfile= @fileone
      @fileone.puts "%%C-Lines = #{@counterlines[0]} + #{@counterlines[1]} + #{@counterlines[2]} + #{@counterlines[3]} (#{totallines})"
      @fileone.puts "%%Email:#{user.email}:#{user.surname}#{user.first}:#{user.first} #{user.surname}" unless user.email.nil?
    else
      @whichfile= @filetwo
      @filetwo.puts "%%C-Lines = #{@counterlines[0]} + #{@counterlines[1]} + #{@counterlines[2]} + #{@counterlines[3]} (#{totallines})"
      @filetwo.puts "%%Email:#{user.email}:#{user.surname}#{user.first}:#{user.first} #{user.surname}" unless user.email.nil?
    end
    #    return if (totallines >= 15)
    @whichfile.print getmacro('family')
    if (user.email.nil?) then
      printparam("#{user.first} #{user.surname}")
    else
      printparam("#{user.first} #{user.surname} (#{user.email})")
    end
    checkaddr(user.street)
    printparam(user.po_box)
    checkaddr(user.town)
    checkaddr(user.state)
    checkaddr(user.zip)
    if (user.pledge.nil?) then
      printparam getmacro('nopledge')
    else
      @whichfile.print '{'
      if (user.pledge.freq == 'Total') then
        @whichfile.print getmacro('totpledge')
        printfloat user.pledge.amount
      else
        @whichfile.print getmacro('pledge')
        printfloat user.pledge.amount
        printparam user.pledge.freq
      end
      @whichfile.print '}'
    end
    @whichfile.print "\n"
    @whichfile.puts getmacro('leadtext')
    q = 0
    while ((q+=1) <= @lastQ) do
      puts "Processing quarter #{q}"
      processQuarter(user, q)
    end
    #    puts '\totalline{0.00}{0.00}{0.00}'
    printmacro('totalline')
    printfloat(@gtotal)
    printfloat(@ototal)
    printfloat(@gtotal + @ototal)
    @whichfile.print "\n"
    @whichfile.puts getmacro('trailingtext')
    @gtotal = @ototal = 0.00
    if (totallines < 15) then
      @fileone.puts "%%EndUser:#{user.email}:#{user.surname}#{user.first}" unless user.email.nil?
    else
      @filetwo.puts "%%EndUser:#{user.email}:#{user.surname}#{user.first}" unless user.email.nil?
    end
  end

  def create_pdf_file()
    printprolog(@fileone)
    printprolog(@filetwo)
    @whichfile = @filetwo
    printparam('16')
    @whichfile.print "\n"
    @whichfile.print getmacro('begin')
    printparam('document')
    @whichfile.print "\n"
    @whichfile = @fileone
    printparam('0')
    @whichfile.print "\n"
    @whichfile.print getmacro('begin')
    printparam('document')
    @whichfile.print "\n"

    if (@userid > 0) then
      users = User.find(@userid)
      allD = Donation.find :all, :conditions => "user_id = #{users.id}"
      processUser users
    else
      users = User.find(:all, :order => :surname)
      users.each do |u|
        #next unless u.status == 'No'
        allD = Donation.find :all, :conditions => "user_id = #{u.id}"
        unless (allD.length == 0) then
          processUser u
        end
      end
    end

    @whichfile = @fileone
    @whichfile.print getmacro('end')
    printparam('document')
    @whichfile.print "\n"

    @whichfile = @filetwo
    @whichfile.print getmacro('end')
    printparam('document')
    @whichfile.print "\n"

    @fileone.close()
    @filetwo.close()

    (system "xelatex #{@userid}singlepage.tex") ||
    (system "xelatex #{@userid}multipage.tex")
    (system "rm *.log *.tex *.aux")
  end
end
