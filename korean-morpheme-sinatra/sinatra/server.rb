require 'sinatra'
require 'sinatra/multi_route'
require 'multi_json'
require 'natto'

set :bind, '0.0.0.0'

POS_ID_DIC = {
  999 => '알수 없음',
  100 => '어말 어미',
  110 => '감탄사',
  120 => '조사',
  130 => '일반 부사',
  131 => '접속 부사',
  140 => '관형사',
  150 => '일반 명사',
  151 => '고유 명사',
  152 => '의존 명사',
  153 => '의존 명사(단위를 나타내는 명사)',
  154 => '대명사',
  155 => '수사',
  160 => '마침표, 물음표, 느낌표',
  161 => '한자',
  162 => '외국어',
  163 => '숫자',
  164 => '쉼표,가운뎃점,콜론,빗금',
  165 => '닫는 괄호 ), ]',
  166 => '여는 괄호 (, [',
  167 => '쉼표,가운뎃점,콜론,빗금',
  168 => '지정안됨',
  169 => '줄임표 …',
  170 => '형용사',
  171 => '부정 지정사',
  172 => '긍정 지정사',
  173 => '동사',
  174 => '보조 용언',
  181 => '체언 접두사',
  182 => '어근',
  183 => '형용사 파생 접미사',
  184 => '명사 파생 접미사',
  185 => '동사 파생 접미사',
}

nm = Natto::MeCab.new

route :get, :post, '/morpheme' do
  text = params[:text].strip rescue ''
  posids = params[:posids].split(',').map { |str| str.strip.to_i } rescue []
  morps = []
  nm.parse(text) do |morp|
    if !morp.is_eos? && (posids.empty? || posids.include?(morp.posid))
      morps << {
        surface: morp.surface,
        posid: morp.posid,
        desc: POS_ID_DIC[morp.posid],
        feature: morp.feature
      }
    end
  end
  content_type :json, charset: 'UTF-8'
  MultiJson.dump({morps: morps})
end
