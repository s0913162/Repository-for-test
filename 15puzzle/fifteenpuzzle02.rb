#! ruby -Ks
### -------- 2010/2/2�u15�p�Y���v 200913162 ���䐳�� -------------------- ###
### 2010/4/8 �X�V�B
### 15�p�Y���̂��߂̑�1��
### �d�l
### �P�D15�p�Y���̂��ꂼ��̗̈��1�����z��ŕ\��
### �Q�D16�̒l������ƁA�󗓂͂ǂ������ʂ���
### �R�D�󗓂̈ړ��\�ꏊ��\������
### �S�D�s�[�X��1�}�X���ړ������āA�p�Y�����������邩�ǂ�������
### �inew!�j�T�D�S��n��J��Ԃ��ăp�Y�����������邩�ǂ�������i��߂�h�~�Ȃ��j
### (���̑��v���O�����̉��ǁA�}�C�i�[�`�F���W)
### --------------------------------------------------------------------- ###

require("benchmark")

class FifteenPuzzle

	def initialize		## ������
		# �ړ������\�ꏊ�������t���O�z��
		@avail_move = {"��"=>true, "��"=>true, "�E"=>true, "��"=>true}
		@puzzle = Array.new	# 15�p�Y���̗̈��\��1�����z��	
	end

	def puzzle
		return @puzzle
	end

	def zeroinsert_manual		## �v�f��16�̈ꎟ���z�񐶐��i�蓮�B�f�o�b�N�p�j
		#@puzzle = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0]	# ����
		#@puzzle = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 13, 14, 15, 12]	# 1��ړ��Ő���
		#@puzzle = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 11, 13, 14, 15, 12]	# 2��ړ��Ő���
		#@puzzle = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 0, 13, 14, 15]	# 3��ړ��Ő���
		#@puzzle = [1, 2, 0, 4, 5, 6, 3, 7, 9, 10, 11, 8, 13, 14, 15, 12]	# 4��ړ��Ő���
		#@puzzle = [1, 2, 3, 4, 0, 5, 6, 7, 9, 10, 11, 8, 13, 14, 15, 12]	# 5��ړ��Ő���
		#@puzzle = [1, 2, 3, 4,  5, 6, 7, 8, 9, 0, 11, 12, 13, 14, 15, 10]	# L135�̃p�Y��
		@puzzle = [1, 2, 3, 0, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 4]	# L136�̃p�Y��
	end
	
	def puzzledisp(disppuzzle)		## �p�Y���`��
		printf("-------------\n")
		printf("|%2d|%2d|%2d|%2d|\n", disppuzzle[0], disppuzzle[1], disppuzzle[2], disppuzzle[3])
		printf("|%2d|%2d|%2d|%2d|\n", disppuzzle[4], disppuzzle[5], disppuzzle[6], disppuzzle[7])
		printf("|%2d|%2d|%2d|%2d|\n", disppuzzle[8], disppuzzle[9], disppuzzle[10], disppuzzle[11])
		printf("|%2d|%2d|%2d|%2d|\n", disppuzzle[12], disppuzzle[13], disppuzzle[14], disppuzzle[15])
		printf("-------------\n")
	end
	
	def ue_number		## �ォ�牽�Ԗڂ����肵�A������Ԃ�
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

	def hidari_number		## �����牽�Ԗڂ����肵�A������Ԃ�
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

	def availablemoving(puzzle)			## �ړ��\�ꏊ�𔻒肵�A�t���O�𗧂Ă�
		availpuzzle = puzzle.dup
		@avail_move['��'] = true
		@avail_move['��'] = true
		@avail_move['�E'] = true
		@avail_move['��'] = true
		if availpuzzle.index(0) >= 0 && availpuzzle.index(0) <= 3
			@avail_move['��'] = false
		end
		if availpuzzle.index(0) >= 12 && availpuzzle.index(0) <= 15
			@avail_move['��'] = false
		end
		if availpuzzle.index(0) == 0 || availpuzzle.index(0) == 4 || availpuzzle.index(0) == 8 || availpuzzle.index(0) == 12
			@avail_move['��'] = false
		end
		if availpuzzle.index(0) == 3 || availpuzzle.index(0) == 7 || availpuzzle.index(0) == 11 || availpuzzle.index(0) == 15
			@avail_move['�E'] = false
		end
	end
	
	def availabledisp		## �ړ��\�ꏊ��\��
		if @avail_move['��'] == true
			print("�� ")
		end
		if @avail_move['��'] == true
			print("�� ")
		end
		if @avail_move['�E'] == true
			print("�E ")
		end
		if @avail_move['��'] == true
			print("��\n")
		end
	end
		
	def positiondisp		## �󗓂̏ꏊ�ƈړ��\�ꏊ��\��
		printf("�󗓂̏ꏊ�͏ォ��%d�ԖځA������%d�Ԗڂł�\n", ue_number(), hidari_number())
		printf("�ړ��\�ꏊ�F")
		availablemoving(@puzzle)	# �ړ��\�ꏊ����
		availabledisp()		# �ړ��\�ꏊ�\��
	end

	def answer_search(anspuzzle)		## ���݂̔Ֆʂ��A�������m�F
		ans = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0]
		if anspuzzle == ans
			return true
		else
			return false
		end
	end

	## ��߂�h�~�Ȃ��J��Ԃ��Bprevpuzzle:�^����ꂽ�z��Aresult:�����܂ł̓��̂�Arepnum�F�[���̏��
	def n_step1(prevpuzzle, result, repnum)
		current = Array.new
		if repnum > 0
			@avail_move.each_key {|key|
				current = prevpuzzle.dup	# �p�Y�����R�s�[
				availablemoving(current)	# �t���O�X�V
				if @avail_move[key] == true
#					puzzledisp(current)			# �p�Y���\��
					zeropos = current.index(0)		# ���Ƃ���0���������ꏊ���L��	
					# �܂�0���ړ��\��4�����̂ǂꂩ�Ɠ���ւ���B���������O�ɒH�������łȂ��ꍇ�ɓ���ւ���i��߂�j
					pos = 0
					if key == '��' && result[result.size - 1] != '��'
						pos = -4
					elsif key == '��' && result[result.size - 1] != '��'
						pos = 4
					elsif key == '�E' && result[result.size - 1] != '��'
						pos = 1
					elsif key == '��' && result[result.size - 1] != '�E'
						pos = -1
					end
					if pos != 0
#						printf("��%s��%d�Ɠ���ւ�\n", key, current[zeropos + pos])
						current[zeropos] = current[zeropos + pos]	# 0�̈ʒu�Ɉړ���̃s�[�X��
						current[zeropos + pos] = 0					# �ړ����0��
						
						# ����ւ���ɐ������ǂ�������
						if answer_search(current) == true	# �����I
							result.push(key)
							return true
						else 	# ���s�Ȃ�ċN����
							result.push(key)		# ���̂���L�^
#							print("�c��ړ��񐔁F", repnum, "\n\n")
							if n_step1(current, result, repnum-1) == true
								return true
							end
						end
					end
				end
			}
		else	# �[���̏�����z������A���^�[��
#			print("�����ł͂Ȃ��̂�1�i�K�߂�\n\n")
			result.pop	# �s�����̓��̂�Ȃ̂ŏ���
			return false
		end

		# �ړ��\�ȃp�^�[���͑S�Ē��ׂ����A�S�ĕs�����ł������ꍇ�A�����ɂ��ǂ蒅��
		result.pop
#		print("�����ł͂Ȃ��̂�1�i�K�߂�\n\n")
		return false
	end
end


## --------- ���ۂ̏����i���C���j ------------- ##
print("�v�f��16�̈ꎟ���z��̂ǂ�����0��}�����܂��B\n")
print("���̌�A�ړ��\�ꏊ��\�����܂��BEnter�������Ă�������\n")
prease_enter = gets	# Enter�������ƈȉ������s


fp = FifteenPuzzle.new	# �N���X������

fp.zeroinsert_manual
fp.puzzledisp(fp.puzzle)
fp.positiondisp	# �󗓂̏ꏊ�ƈړ��\�ꏊ��\��

print("���̔Ֆʂ����������肵�܂��BEnter�������Ă�������\n")
prease_enter = gets	# Enter�������ƈȉ������s

## --- �x���`�}�[�N�J�n --- ##

Benchmark.bm{ |x|
x.report{
	deep = 1	# �[���̏��(�ŏ���1)
	result = Array.new	# �����܂ł̓��̂�
	
	correctanswer = fp.answer_search(fp.puzzle)
	if correctanswer == true	# �����炸�Ƃ����̌`������
		print("���茋�ʁF����\n")
	else
#		print("���茋�ʁF���s\n")
#		print("�����Ĕ����[���@�Ő����ɂȂ邩�ǂ������肵�܂��B\n")
#		print("�[���̏��", deep, "\n")
		correctanswer = fp.n_step1(fp.puzzle, result, deep)
		while correctanswer != true && deep < 20		# �[��20�܂Ŕ����[��
			result = Array.new	# �����܂ł̓��̂�
			deep += 1
			correctanswer = fp.n_step1(fp.puzzle, result, deep)
		end
		if correctanswer == true
			print("�ŏI���茋�ʁF����\n")
			print("�����܂ł̓��̂�F", result, "\n")
		elsif
			print("�ŏI���茋�ʁF���s\n")
		end
	end
	}
}
print("Enter�������ƏI�����܂�\n")
prease_enter = gets

