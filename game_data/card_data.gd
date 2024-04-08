
class_name CardData

enum CardType {ユニット,特技,武器}
enum Keyword {
	召喚時,
	死亡時,
	占い,
	攻撃時,
	テンションリンク,
	前列召喚時,
	におうだち,
	速攻,
	ステルス,
	ねらい撃ち,
	二回攻撃,
	貫通,
	超貫通,
	メタルボディ,
	必殺技,
	
	毒,
	攻撃不能,
	封印
}
enum UnitStrain {なし,スライム,ゾンビ}
enum Pack {ベーシック,スタンダード}


var id : int
var name : String
var type : CardType
var cost : int
var attack : int
var hp : int
var keyword : Array[Keyword] = []
var strain : UnitStrain
var pack : Pack
var rarity : int
var text : String
var relation : Array[int] = []


static var list : Dictionary
static func get_card_data(_id : int) -> CardData:
	return list.get(_id)

static func _static_init():
	var source := """
1,スライム,ユニット,0,1,1,,スライム,ベーシック,0,,
2,ファーラット,ユニット,1,1,1,速攻,,ベーシック,0,{速攻},
3,スライムつむり,ユニット,1,1,2,におうだち,スライム,ベーシック,0,{におうだち},
4,メラゴースト,ユニット,1,1,1,,,ベーシック,0,{召喚時}:\\n1ダメージを与える,
5,スライムベス,ユニット,1,2,1,,スライム,ベーシック,0,,
6,リザードマン,ユニット,2,3,2,,ドラゴン,ベーシック,0,,
7,シールドこぞう,ユニット,2,2,2,におうだち,,ベーシック,0,{におうだち},
8,いっかくうさぎ,ユニット,2,2,1,速攻,,ベーシック,0,{速攻},
9,バードファイター,ユニット,3,4,3,,,ベーシック,0,,
10,くさった死体,ユニット,3,3,3,,ゾンビ,ベーシック,0,{召喚時}:\\n敵リーダーの\\n武器を破壊する,
"""
	var lines := source.split("\n",false)
	list.clear()
	for l in lines:
		var cell := l.split(",")
		var c = CardData.new()
		c.id = int(cell[0])
		c.name = cell[1]
		c.type = CardType.get(cell[2])
		c.cost = int(cell[3])
		c.attack = int(cell[4])
		c.hp = int(cell[5])
		c.keyword.clear()
		for k in cell[6].split(" ",false):
			c.keyword.append(Keyword.get(k))
		c.strain = UnitStrain.get(cell[7],UnitStrain.なし)
		c.pack = Pack.get(cell[8])
		c.rarity = int(cell[9])
		c.text = cell[10]
		c.relation.clear()
		for r in cell[11].split(" ",false):
			c.relation.append(int(r))
		list[c.id] = c
		


