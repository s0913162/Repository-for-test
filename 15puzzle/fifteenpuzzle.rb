#! ruby -Ks
### -------- 2010/2/2「15パズル」 200913162 高井正成 ------------------- ###
### 15パズルのための第1歩
### 仕様
### １．15パズルのそれぞれの領域を1次元配列で表現
### ２．16個の値を入れると、空欄はどこか判別する
### ３．空欄の移動可能場所を表示する
### ４．ピースを1マス分移動させて、パズルが完成するかどうか判定
### （new!）５．４をn回繰り返してパズルが完成するかどうか判定（後戻り防止なし）
### --------------------------------------------------------------------- ###

class FifteenPuzzle

	def initialize		## 初期化
		# 移動方向可能場所を示すフラグ
		@avail_move = {"上"=>true, "下"=>true, "右"=>true, "左"=>true}

		@puzzle = Array.new	# 15パズルの領域を表す1次元配列	
		@puzzle_initialstate = Array.new	# 作成された一次元配列保存用
		@puzzle_prev = Array.new
	end

	def zeroinsert_auto		## 要素数16の一次元配列生成（自動）
		i = 0
		space = rand(16)	# どこに0を入れるか乱数生成
		spacenumber = 1		# 順番にマスに番号を入れるとき使用
		while i < 16
			if(i == space)
				@puzzle[i] = 0
				@puzzle_initialstate[i]
			else
				@puzzle[i] = spacenumber
				@puzzle_initialstate[i] = spacenumber
				spacenumber += 1
			end
			i += 1
		end
	end

	def zeroinsert_manual		## 要素数16の一次元配列生成（手動。デバック用）
		# @puzzle = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0]
		# @puzzle = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 13, 14, 15, 12]
		 @puzzle = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 11, 13, 14, 15, 12]
		@puzzle_initialstate = @puzzle.dup	# 作成された一次元配列を保存しておく
	end
	
	def puzzledisp		## パズル描画
		printf("-------------\n")
		printf("|%2d|%2d|%2d|%2d|\n", @puzzle[0], @puzzle[1], @puzzle[2], @puzzle[3])
		printf("|%2d|%2d|%2d|%2d|\n", @puzzle[4], @puzzle[5], @puzzle[6], @puzzle[7])
		printf("|%2d|%2d|%2d|%2d|\n", @puzzle[8], @puzzle[9], @puzzle[10], @puzzle[11])
		printf("|%2d|%2d|%2d|%2d|\n", @puzzle[12], @puzzle[13], @puzzle[14], @puzzle[15])
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

	def availablemoving			## 移動可能場所を判定し、フラグを立てる
		@avail_move['上'] = true
		@avail_move['下'] = true
		@avail_move['右'] = true
		@avail_move['左'] = true
		if @puzzle.index(0) >= 0 && @puzzle.index(0) <= 3
			@avail_move['上'] = false
		end
		if @puzzle.index(0) >= 12 && @puzzle.index(0) <= 15
			@avail_move['下'] = false
		end
		if @puzzle.index(0) == 0 || @puzzle.index(0) == 4 || @puzzle.index(0) == 8 || @puzzle.index(0) == 12
			@avail_move['左'] = false
		end
		if @puzzle.index(0) == 3 || @puzzle.index(0) == 7 || @puzzle.index(0) == 11 || @puzzle.index(0) == 15
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
		availablemoving()	# 移動可能場所判定
		availabledisp()		# 移動可能場所表示
	end

	def answer_search		## 現在の盤面が、正解か確認
		ans = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0]
		if @puzzle == ans
			return true
		else
			return false
		end
	end

	def one_search		## 一手先を調べて、正解のパズルか確認
		availablemoving()	# フラグ更新
		@avail_move.each_key {|key|
			if @avail_move[key] == true	# パズルを入れ替えて比較
				puzzledisp()
				zeropos = @puzzle.index(0)									# もともと0があった場所を記憶
				case key
					when '上'
						pos = -4
					when '下'
						pos = 4
					when '右'
						pos = 1
					when '左'
						pos = -1
				end
				printf("空欄上の%dと入れ替え\n", @puzzle[zeropos + pos])
				@puzzle[zeropos] = @puzzle[zeropos + pos]	# 0の位置に移動先のピースを
				@puzzle[zeropos + pos] = 0									# 元0の真上に0を
				if answer_search() == true
					print("比較結果：正解\n")
					return
				else 
					print("比較結果：失敗\n")
					# 再起処理
					# 書き込み予定地
				end
			end
			@puzzle = @puzzle_initialstate	# 比較時に変化させたパズルを初期状態に戻す
		}
	end

	def n_step1(result, repnum)	## 後戻り防止なし繰り返し。result:正解までの道のり、repnum：深さの上限
				
		if repnum <= 0
			print("やり直し\n\n")
			result.pop	# 不正解の道のりなので消去
			@puzzle = @puzzle_prev.dup	# 比較時に変化させたパズルを1つ前の状態に戻す
			#repnum = 2	# 深さの上限も元の状態に戻す
			#print("puzzle初期化", @puzzle, "\n")
			return false	# 0以下なら違う枝を探索
		else
			availablemoving()	# フラグ更新
			@avail_move.each_key {|key|
				#print(key, "\n")
				if @avail_move[key] == true	# パズルを入れ替えて比較
					puzzledisp()			# パズル表示
					zeropos = @puzzle.index(0)		# もともと0があった場所を記憶
					@puzzle_prev = @puzzle.dup	# 現在の状態を保存（変化の1つ前の状態を保持）
					case key
					when '上'
						printf("空欄上の%dと入れ替え\n", @puzzle[zeropos - 4])
						@puzzle[zeropos] = @puzzle[zeropos - 4]	# 0の位置に移動先のピースを
						@puzzle[zeropos - 4] = 0					# 元0の真上に0を
						if answer_search() == true
							result.push(key)
							return true
						else 	# 失敗なら再起処理
							result.push(key)
							# 再起処理
							print("残り移動回数：", repnum, "\n\n")
							if n_step1(result, repnum-1) == true
								return true
							end
						end
					when '下'
						printf("空欄下の%dと入れ替え\n", @puzzle[zeropos + 4])
						@puzzle[zeropos] = @puzzle[zeropos + 4]	# 0の位置に移動先のピースを
						@puzzle[zeropos + 4] = 0					# 元0の真上に0を
						if answer_search() == true
							result.push(key)
							return true
						else 	# 失敗なら再起処理
							result.push(key)
							# 再起処理
							print("残り移動回数：", repnum, "\n\n")
							if n_step1(result, repnum-1) == true
								return true
							end
						end
					when '右'
						printf("空欄右の%dと入れ替え\n", @puzzle[zeropos + 1])
						@puzzle[zeropos] = @puzzle[zeropos + 1]	# 0の位置に移動先のピースを
						@puzzle[zeropos + 1] = 0					# 元0の真上に0を
						if answer_search() == true
							result.push(key)
							return true
						else 	# 失敗なら再起処理
							result.push(key)
							# 再起処理
							print("残り移動回数：", repnum, "\n\n")
							if n_step1(result, repnum-1) == true
								return true
							end
						end
					when '左'
						printf("空欄左の%dと入れ替え\n", @puzzle[zeropos - 1])
						@puzzle[zeropos] = @puzzle[zeropos - 1]	# 0の位置に移動先のピースを
						@puzzle[zeropos - 1] = 0					# 元0の真上に0を
						if answer_search() == true
							result.push(key)
							return true
						else 	# 失敗なら再起処理
							result.push(key)
							# 再起処理
							print("残り移動回数：", repnum, "\n\n")
							if n_step1(result, repnum-1) == true
								return true
							end
						end
					end
				end
			}
		end
		result.pop	# 不正解の道のりなので消去
		print("不可能な道のりなのでリセット\n\n")
		@puzzle = @puzzle_initialstate.dup	# 比較時に変化させたパズルを元の状態に戻す
		return false	# 0以下なら違う枝を探索
	end
end


## --------- 実際の処理（メイン） ------------- ##
print("要素数16の一次元配列のどこかに0を挿入します。\n")
print("その後、移動可能場所を表示します。Enterを押してください\n")
prease_enter = gets	# Enterを押すと以下を実行


fp = FifteenPuzzle.new	# クラス初期化

# fp.zeroinsert_auto
fp.zeroinsert_manual
fp.puzzledisp
fp.positiondisp	# 空欄の場所と移動可能場所を表示

print("この盤面が正解か判定します。Enterを押してください\n")
prease_enter = gets	# Enterを押すと以下を実行

deep = 2	# 深さの上限

result = Array.new	# 正解までの道のり

if fp.answer_search == true
	print("判定結果：正解\n")
else
	print("判定結果：失敗\n")
	print("続けて反復深化法で正解になるかどうか判定します。\n")
	print("深さの上限", deep, "\n")
	if fp.n_step1(result, deep) == true
		print("最終判定結果：正解\n")
		print("正解までの道のり：", result)
	else
		print("最終判定結果：失敗\n")
	end
end

