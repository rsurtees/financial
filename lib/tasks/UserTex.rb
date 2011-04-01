class UserTex

  def initialize()
    @@fileone = File.new("singlepage.tex", "w")
    @@filetwo = File.new("multipage.tex", "w")
    #@@whichfile = @@fileone

    @gtotal = 0.00
    @ototal       = 0.00
    @counterlines = [0, 0, 0, 0]
  end

  def getmacro(m)
    "\\#{m}"
  end

  def printmacro(m)
    @@whichfile.print getmacro(m)
  end

  def printparam(s)
    @@whichfile.print "{#{s}}"
  end

  def printfloat(f)
    printparam(sprintf("%.2f", f))
  end

  def printdollar(f)
    printparam(getmacro('$') << sprintf("%.2f", f))
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
      @@whichfile.print "\n"
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
    @@whichfile.print "\n"
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
    processLines(user, 1)
    processLines(user, 2)
    processLines(user, 3)
    processLines(user, 4)
    totallines = @counterlines[0] + @counterlines[1] + @counterlines[2] + @counterlines[3]
    if (totallines < 15) then
      @@whichfile= @@fileone
      @@fileone.puts "%%C-Lines = #{@counterlines[0]} + #{@counterlines[1]} + #{@counterlines[2]} + #{@counterlines[3]} (#{totallines})"
      @@fileone.puts "%%Email:#{user.email}:#{user.surname}#{user.first}:#{user.first} #{user.surname}" unless user.email.nil?
    else
      @@whichfile= @@filetwo
      @@filetwo.puts "%%C-Lines = #{@counterlines[0]} + #{@counterlines[1]} + #{@counterlines[2]} + #{@counterlines[3]} (#{totallines})"
      @@filetwo.puts "%%Email:#{user.email}:#{user.surname}#{user.first}:#{user.first} #{user.surname}" unless user.email.nil?
    end
    #    return if (totallines >= 15)
    @@whichfile.print getmacro('family')
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
      @@whichfile.print '{'
      if (user.pledge.freq == 'Total') then
        @@whichfile.print getmacro('totpledge')
        printfloat user.pledge.amount
      else
        @@whichfile.print getmacro('pledge')
        printfloat user.pledge.amount
        printparam user.pledge.freq
      end
      @@whichfile.print '}'
    end
    @@whichfile.print "\n"
    #if ((totallines > 14) && (totallines < 22)) then
    #	printmacro('renewcommand')
    #	@@whichfile.print '{'
    #	printmacro('totalbreak')
    #	@@whichfile.print '}'
    #	@@whichfile.print '{'
    #	@@whichfile.print('\\newpage')
    #	@@whichfile.print '}'
    #	@@whichfile.print "\n"
    #	else
    #	printmacro('renewcommand')
    #	@@whichfile.print '{'
    #	printmacro('totalbreak')
    #	@@whichfile.print '}{}'
    #	@@whichfile.print "\n"
    #end
    @@whichfile.puts getmacro('leadtext')
    processQuarter(user, 1)
    processQuarter(user, 2)
    processQuarter(user, 3)
    processQuarter(user, 4)
    #    puts '\totalline{0.00}{0.00}{0.00}'
    printmacro('totalline')
    printfloat(@gtotal)
    printfloat(@ototal)
    printfloat(@gtotal + @ototal)
    @@whichfile.print "\n"
    @@whichfile.puts getmacro('trailingtext')
    @gtotal = @ototal = 0.00
    if (totallines < 15) then
      @@fileone.puts "%%EndUser:#{user.email}:#{user.surname}#{user.first}" unless user.email.nil?
    else
      @@filetwo.puts "%%EndUser:#{user.email}:#{user.surname}#{user.first}" unless user.email.nil?
    end
  end

  def createTex()
    @@whichfile = @@filetwo
    @@whichfile.print getmacro('include')
    printparam('NBCprolog')
    @@whichfile.print getmacro('usepackage')
    printparam('ifthen')
    @@whichfile.print "\n"
    @@whichfile.print getmacro('newcounter')
    printparam('pagelines')
    @@whichfile.print getmacro('setcounter')
    printparam('pagelines')
    printparam('16')
    @@whichfile.print "\n"
    @@whichfile.print getmacro('begin')
    printparam('document')
    @@whichfile.print "\n"
    @@whichfile = @@fileone
    @@whichfile.print getmacro('include')
    printparam('NBCprolog')
    @@whichfile.print getmacro('usepackage')
    printparam('ifthen')
    @@whichfile.print "\n"
    @@whichfile.print getmacro('newcounter')
    printparam('pagelines')
    @@whichfile.print getmacro('setcounter')
    printparam('pagelines')
    printparam('0')
    @@whichfile.print "\n"
    @@whichfile.print getmacro('begin')
    printparam('document')
    @@whichfile.print "\n"

    users = User.find(:all, :order => :surname)

    users.each do |u|
      #   next unless u.status == 'No'
      allD = Donation.find :all, :conditions => "user_id = #{u.id}"
      unless (allD.length == 0) then
        processUser u
      end
    end

    @@whichfile = @@fileone
    @@whichfile.print getmacro('end')
    printparam('document')
    @@whichfile.print "\n"

    @@whichfile = @@filetwo
    @@whichfile.print getmacro('end')
    printparam('document')
    @@whichfile.print "\n"

    @@fileone.close()
    @@filetwo.close()
  end

  def createPDF()
    system "xelatex single.tex"
    system "xelatex multi.tex"
  end
end
