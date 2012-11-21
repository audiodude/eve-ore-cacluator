require 'rexml/document'
require 'httparty'
require 'sqlite3'

db = SQLite3::Database.new('prices.sqlite')

regions = [
  10000019, 10000054, 10000069, 10000055, 10000007, 10000014, 10000051, 10000053, 10000012, 10000035, 10000060, 10000001, 10000005, 10000036,
  10000064, 10000027, 10000037, 10000046, 10000056, 10000058, 10000029, 10000067, 10000011, 10000030, 10000025, 10000031, 10000017, 10000052,
  10000034, 10000049, 10000065, 10000016, 10000013, 10000042, 10000028, 10000040, 10000062, 10000021, 10000057, 10000059, 10000063, 10000066,
  10000048, 10000047, 10000023, 10000050, 10000008, 10000032, 10000044, 10000022, 10000041, 10000020, 10000045, 10000061, 10000038, 10000033,
  10000002, 10000018, 10000010, 10000004, 10000003, 10000015, 10000068, 10000006, 10000043, 10000039
]

regions.each do |r|
  url = 'http://api.eve-central.com/api/marketstat?typeid=34&typeid=38&typeid=35&typeid=36&typeid=37&typeid=39&typeid=40&typeid=11399&regionlimit='+ r.to_s
  res = HTTParty.get(url)
  doc = REXML::Document.new res.body

  vals = {'region_id' => r, 'ts' => Time.now.to_i }
  doc.elements.each('//type') do |ele|
    case ele.attributes['id'].to_i
      when 34
        vals['trit_buy']  = ele.elements["buy/median"].text
        vals['trit_sell'] = ele.elements["sell/median"].text
      when 38
        vals['noc_buy']  = ele.elements["buy/median"].text
        vals['noc_sell'] = ele.elements["sell/median"].text
      when 35
        vals['pye_buy']  = ele.elements["buy/median"].text
        vals['pye_sell'] = ele.elements["sell/median"].text
      when 36
        vals['mex_buy']  = ele.elements["buy/median"].text
        vals['mex_sell'] = ele.elements["sell/median"].text
      when 37
        vals['iso_buy']  = ele.elements["buy/median"].text
        vals['iso_sell'] = ele.elements["sell/median"].text
      when 39
        vals['zyd_buy']  = ele.elements["buy/median"].text
        vals['zyd_sell'] = ele.elements["sell/median"].text
      when 40
        vals['meg_buy']  = ele.elements["buy/median"].text
        vals['meg_sell'] = ele.elements["sell/median"].text
      when 11399
        vals['mor_buy']  = ele.elements["buy/median"].text
        vals['mor_sell'] = ele.elements["sell/median"].text
      else
        puts ele.attributes["id"].to_i
    end
  end

  db.execute(<<EOS, vals)
  INSERT INTO prices (region_id, trit_buy, trit_sell, noc_buy, noc_sell, pye_buy, pye_sell,
                      mex_buy, mex_sell, iso_buy, iso_sell, zyd_buy, zyd_sell, meg_buy,
                      meg_sell, mor_buy, mor_sell, ts)
  VALUES (:region_id, :trit_buy, :trit_sell, :noc_buy, :noc_sell, :pye_buy, :pye_sell,
                      :mex_buy, :mex_sell, :iso_buy, :iso_sell, :zyd_buy, :zyd_sell, :meg_buy,
                      :meg_sell, :mor_buy, :mor_sell, :ts)
EOS

end
