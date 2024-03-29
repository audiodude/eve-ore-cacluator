require 'rubygems'
require 'sinatra'
require 'sqlite3'
require 'hashie'

db = SQLite3::Database.new('prices.sqlite')

get '/' do
  @region_to_name = {
      10000019=>'A821-A', 10000054=>'Aridia', 10000069=>'Black Rise', 10000055=>'Branch',
      10000007=>'Cache', 10000014=>'Catch', 10000051=>'Cloud Ring', 10000053=>'Cobalt Edge',
      10000012=>'Curse', 10000035=>'Deklein', 10000060=>'Delve', 10000001=>'Derelik',
      10000005=>'Detorid', 10000036=>'Devoid', 10000043=>'Domain', 10000039=>'Esoteria',
      10000064=>'Essence', 10000027=>'Etherium Reach', 10000037=>'Everyshore', 10000046=>'Fade',
      10000056=>'Feythabolis', 10000058=>'Fountain', 10000029=>'Geminate', 10000067=>'Genesis',
      10000011=>'Great Wildlands', 10000030=>'Heimatar', 10000025=>'Immensea', 10000031=>'Impass',
      10000017=>'J7HZ-F', 10000052=>'Kador', 10000034=>'Kalevala Expanse', 10000049=>'Khanid',
      10000065=>'Kor-Azor', 10000016=>'Lonetrek', 10000013=>'Malpais', 10000042=>'Metropolis',
      10000028=>'Molden Heath', 10000040=>'Oasa', 10000062=>'Omist', 10000021=>'Outer Passage',
      10000057=>'Outer Ring', 10000059=>'Paragon Soul', 10000063=>'Period Basis',
      10000066=>'Perrigen Falls', 10000048=>'Placid', 10000047=>'Providence', 10000023=>'Pure Blind',
      10000050=>'Querious', 10000008=>'Scalding Pass', 10000032=>'Sinq Laison', 10000044=>'Solitude',
      10000022=>'Stain', 10000041=>'Syndicate', 10000020=>'Tash-Murkon', 10000045=>'Tenal',
      10000061=>'Tenerifis', 10000038=>'The Bleak Lands', 10000033=>'The Citadel', 10000002=>'The Forge',
      10000018=>'The Spire', 10000010=>'Tribute', 10000004=>'UUA-F4', 10000003=>'Vale of the Silent',
      10000015=>'Venal', 10000068=>'Verge Vendor', 10000006=>'Wicked Creek'
  }

  @prices = []
  db.execute(<<EOS
    SELECT region_id, trit_buy, trit_sell, noc_buy, noc_sell, pye_buy, pye_sell,
           mex_buy, mex_sell, iso_buy, iso_sell, zyd_buy, zyd_sell, meg_buy,
           meg_sell, mor_buy, mor_sell FROM prices GROUP BY region_id HAVING ts = max(ts)
EOS
).each do |row|
    p = Hashie::Mash.new
    p.region_id, p.trit_buy, p.trit_sell, p.noc_buy, p.noc_sell, p.pye_buy, p.pye_sell,
      p.mex_buy, p.mex_sell, p.iso_buy, p.iso_sell, p.zyd_buy, p.zyd_sell, p.meg_buy,
      p.meg_sell, p.mor_buy, p.mor_sell = row
    @prices << p
  end

  erb :ore
end
