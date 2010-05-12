#! ruby -Ks
### -------- 2010/2/2「15パズル」 200913162 高井正成 -------------------- ###
### 2010/4/8 更新。
### 15パズルのための第1歩
### 仕様
### １．15パズルのそれぞれの領域を1次元配列で表現
### ２．16個の値を入れると、空欄はどこか判別する
### ３．空欄の移動可能場所を表示する
### ４．ピースを1マス分移動させて、パズルが完成するかどうか判定
### （new!）５．４をn回繰り返してパズルが完成するかどうか判定（後戻り防止なし）
### (その他プログラムの改良、マイナーチェンジ)
### --------------------------------------------------------------------- ###

require("benchmark")

class FifteenPuzzle

	def initialize		## 初期化
		# 移動方向可能場所を示すフラグ配列
		@avail_move = {"上"=>true, "下"=>true, "右"=>true, "左"=>true}
		@puzzle = Array.new	# 15パズルの領域を表す1次元配列	
	end

	def puzzle
		return @puzzle
	end

	def zeroinsert_manual		## 要素数16の一次元配列生成（手動。デバック用）
		#@puzzle = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0]	# 正解
		#@puzzle = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 13, 14, 15, 12]	# 1回移動で成功
		#@puzzle = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 11, 13, 14, 15, 12]	# 2回移動で成功
		#@puzzle = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 0, 13, 14, 15]	# 3回移動で成功
		#@puzzle = [1, 2, 0, 4, 5, 6, 3, 7, 9, 10, 11, 8, 13, 14, 15, 12]	# 4回移動で成功
		#@puzzle = [1, 2, 3, 4, 0, 5, 6, 7, 9, 10, 11, 8, 13, 14, 15, 12]	# 5回移動で成功
		#@puzzle = [1, 2, 3, 4,  5, 6, 7, 8, 9, 0, 11, 12, 13, 14, 15, 10]	# L135のパズル
		@puzzle = [1, 2, 3, 0, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 4]	# L136のパズル
	end
	
	def puzzledisp(disppuzzle)		## パズル描画
		printf("-------------\n")
		printf("|%2d|%2d|%2d|%2d|\n", disppuzzle[0], disppuzzle[1], disppuzzle[2], disppuzzle[3])
		printf("|%2d|%2d|%2d|%2d|\n", disppuzzle[4], disppuzzle[5], disppuzzle[6], disppuzzle[7])
		printf("|%2d|%2d|%2d|%2d|\n", disppuzzle[8], disppuzzle[9], disppuzzle[10], disppuzzle[11])
		printf("|%2d|%2d|%2d|%2d|\n", disppuzzle[12], disppuzzle[13], disppuzzle[14], disppuzzle[15])
		printf("-------------\n")
	end
	
	def ue_number		## 上から何番目か判定し、数字を返す
		if @puzzle.index(0) >= 0 && @puzzle.index(0) <= 3
			return 1
		elsif @puzzle.index(0) >= 4 && @puzzle.index(0) <= 7
			return 2
		elsif @puzzle.index(0) >= 8 && @puzzle.index(0) <= 11
			return 3
		elsif @puzzle.index(0) >= 12 && @puzzle.index(0) <= 15
			return 4
		end
	end

	def hidari_number		## 左から何番目か判定し、数字を返す
		if @puzzle.index(0) == 0 || @puzzle.index(0) == 4 ||
						@puzzle.index(0) == 8 || @puzzle.index(0) == 12
			return 1
		elsif @puzzle.index(0) == 1 || @puzzle.index(0) == 5 ||
						@puzzle.index(0) == 9 || @puzzle.index(0) == 13
			return 2
		elsif @puzzle.index(0) == 2 || @puzzle.index(0) == 6 ||
						@puzzle.index(0) == 10 || @puzzle.index(0) == 14
			return 3
		elsif @puzzle.index(0) == 3 || @puzzle.index(0) == 7 ||
						@puzzle.index(0) == 11 || @puzzle.index(0) == 15
			return 4
		end
	end

	def availablemoving(puzzle)			## 移動可能場所を判定し、フラグを立てる
		availpuzzle = puzzle.dup
		@avail_move['上'] = true
		@avail_move['下'] = true
		@avail_move['右'] = true
		@avail_move['左'] = true
		if availpuzzle.index(0) >= 0 && availpuzzle.index(0) <= 3
			@avail_move['上'] = false
		end
		if availpuzzle.index(0) >= 12 && availpuzzle.index(0) <= 15
			@avail_move['下'] = false
		end
		if availpuzzle.index(0) == 0 || availpuzzle.index(0) == 4 || availpuzzle.index(0) == 8 || availpuzzle.index(0) == 12
			@avail_move['左'] = false
		end
		if availpuzzle.index(0) == 3 || availpuzzle.index(0) == 7 || availpuzzle.index(0) == 11 || availpuzzle.index(0) == 15
			@avail_move['右'] = false
		end
	end
	
	def availabledisp		## 移動可能場所を表示
		if @avail_move['上'] == true
			print("上 ")
		end
		if @avail_move['下'] == true
			print("下 ")
		end
		if @avail_move['右'] == true
			print("右 ")
		end
		if @avail_move['左'] == true
			print("左\n")
		end
	end
		
	def positiondisp		## 空欄の場所と移動可能場所を表示
		printf("空欄の場所は上から%d番目、左から%d番目です\n", ue_number(), hidari_number())
		printf("移動可能場所：")
		availablemoving(@puzzle)	# 移動可能場所判定
		availabledisp()		# 移動可能場所表示
	end

	def answer_search(anspuzzle)		## 現在の盤面が、正解か確認
		ans = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0]
		if anspuzzle == ans
			return true
		else
			return false
		end
	end

	## 後戻り防止なし繰り返し。prevpuzzle:与えられた配列、result:正解までの道のり、repnum：深さの上限
	def n_step1(prevpuzzle, result, repnum)
		current = Array.new
		if repnum > 0
			@avail_move.each_key {|key|
				current = prevpuzzle.dup	# パズルをコピー
				availablemoving(current)	# フラグ更新
				if @avail_move[key] == true
#					puzzledisp(current)			# パズル表示
					zeropos = current.index(0)		# もともと0があった場所を記憶	
					# まず0を移動可能な4方向のどれかと入れ替える。ただし直前に辿った道でない場合に入れ替える（後戻り）
					pos = 0
					if key == '上' && result[result.size - 1] != '下'
						pos = -4
					elsif key == '下' && result[result.size - 1] != '上'
						pos = 4
					elsif key == '右' && result[result.size - 1] != '左'
						pos = 1
					elsif key == '左' && result[result.size - 1] != '右'
						pos = -1
					end
					if pos != 0
#						printf("空欄%sの%dと入れ替え\n", key, current[zeropos + pos])
						current[zeropos] = current[zeropos + pos]	# 0の位置に移動先のピースを
						current[zeropos + pos] = 0					# 移動先に0を
						
						# 入れ替え後に正解かどうか判定
						if answer_search(current) == true	# 正解！
							result.push(key)
							return true
						else 	# 失敗なら再起処理
							result.push(key)		# 道のりを記録
#							print("残り移動回数：", repnum, "\n\n")
							if n_step1(current, result, repnum-1) == true
								return true
							end
						end
					end
				end
			}
		else	# 深さの上限を越えたら、リターン
#			print("正解ではないので1段階戻る\n\n")
			result.pop	# 不正解の道のりなので消去
			return false
		end

		# 移動可能なパターンは全て調べたが、全て不正解であった場合、ここにたどり着く
		result.pop
#		print("正解ではないので1段階戻る\n\n")
		return false
	end
end


## --------- 実際の処理（メイン） ------------- ##
print("要素数16の一次元配列のどこかに0を挿入します。\n")
print("その後、移動可能場所を表示します。Enterを押してください\n")
prease_enter = gets	# Enterを押すと以下を実行


fp = FifteenPuzzle.new	# クラス初期化

fp.zeroinsert_manual
fp.puzzledisp(fp.puzzle)
fp.positiondisp	# 空欄の場所と移動可能場所を表示

print("この盤面が正解か判定します。Enterを押してください\n")
prease_enter = gets	# Enterを押すと以下を実行

## --- ベンチマーク開始 --- ##

Benchmark.bm{ |x|
x.report{
	deep = 1	# 深さの上限(最初は1)
	result = Array.new	# 正解までの道のり
	
	correctanswer = fp.answer_search(fp.puzzle)
	if correctanswer == true	# いじらずともこの形が正解
		print("判定結果：正解\n")
	else
#		print("判定結果：失敗\n")
#		print("続けて反復深化法で正解になるかどうか判定します。\n")
#		print("深さの上限", deep, "\n")
		correctanswer = fp.n_step1(fp.puzzle, result, deep)
		while correctanswer != true && deep < 20		# 深さ20まで反復深化
			result = Array.new	# 正解までの道のり
			deep += 1
			correctanswer = fp.n_step1(fp.puzzle, result, deep)
		end
		if correctanswer == true
			print("最終判定結果：正解\n")
			print("正解までの道のり：", result, "\n")
		elsif
			print("最終判定結果：失敗\n")
		end
	end
	}
}
print("Enterを押すと終了します\n")
prease_enter = gets

