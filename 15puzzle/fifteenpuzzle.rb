#! ruby -Ks
### -------- 2010/2/2�u15�p�Y���v 200913162 ���䐳�� ------------------- ###
### 15�p�Y���̂��߂̑�1��
### �d�l
### �P�D15�p�Y���̂��ꂼ��̗̈��1�����z��ŕ\��
### �Q�D16�̒l������ƁA�󗓂͂ǂ������ʂ���
### �R�D�󗓂̈ړ��\�ꏊ��\������
### �S�D�s�[�X��1�}�X���ړ������āA�p�Y�����������邩�ǂ�������
### �inew!�j�T�D�S��n��J��Ԃ��ăp�Y�����������邩�ǂ�������i��߂�h�~�Ȃ��j
### --------------------------------------------------------------------- ###

class FifteenPuzzle

	def initialize		## ������
		# �ړ������\�ꏊ�������t���O
		@avail_move = {"��"=>true, "��"=>true, "�E"=>true, "��"=>true}

		@puzzle = Array.new	# 15�p�Y���̗̈��\��1�����z��	
		@puzzle_initialstate = Array.new	# �쐬���ꂽ�ꎟ���z��ۑ��p
		@puzzle_prev = Array.new
	end

	def zeroinsert_auto		## �v�f��16�̈ꎟ���z�񐶐��i�����j
		i = 0
		space = rand(16)	# �ǂ���0�����邩��������
		spacenumber = 1		# ���ԂɃ}�X�ɔԍ�������Ƃ��g�p
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

	def zeroinsert_manual		## �v�f��16�̈ꎟ���z�񐶐��i�蓮�B�f�o�b�N�p�j
		# @puzzle = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0]
		# @puzzle = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 13, 14, 15, 12]
		 @puzzle = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 11, 13, 14, 15, 12]
		@puzzle_initialstate = @puzzle.dup	# �쐬���ꂽ�ꎟ���z���ۑ����Ă���
	end
	
	def puzzledisp		## �p�Y���`��
		printf("-------------\n")
		printf("|%2d|%2d|%2d|%2d|\n", @puzzle[0], @puzzle[1], @puzzle[2], @puzzle[3])
		printf("|%2d|%2d|%2d|%2d|\n", @puzzle[4], @puzzle[5], @puzzle[6], @puzzle[7])
		printf("|%2d|%2d|%2d|%2d|\n", @puzzle[8], @puzzle[9], @puzzle[10], @puzzle[11])
		printf("|%2d|%2d|%2d|%2d|\n", @puzzle[12], @puzzle[13], @puzzle[14], @puzzle[15])
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

	def availablemoving			## �ړ��\�ꏊ�𔻒肵�A�t���O�𗧂Ă�
		@avail_move['��'] = true
		@avail_move['��'] = true
		@avail_move['�E'] = true
		@avail_move['��'] = true
		if @puzzle.index(0) >= 0 && @puzzle.index(0) <= 3
			@avail_move['��'] = false
		end
		if @puzzle.index(0) >= 12 && @puzzle.index(0) <= 15
			@avail_move['��'] = false
		end
		if @puzzle.index(0) == 0 || @puzzle.index(0) == 4 || @puzzle.index(0) == 8 || @puzzle.index(0) == 12
			@avail_move['��'] = false
		end
		if @puzzle.index(0) == 3 || @puzzle.index(0) == 7 || @puzzle.index(0) == 11 || @puzzle.index(0) == 15
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
		availablemoving()	# �ړ��\�ꏊ����
		availabledisp()		# �ړ��\�ꏊ�\��
	end

	def answer_search		## ���݂̔Ֆʂ��A�������m�F
		ans = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0]
		if @puzzle == ans
			return true
		else
			return false
		end
	end

	def one_search		## ����𒲂ׂāA�����̃p�Y�����m�F
		availablemoving()	# �t���O�X�V
		@avail_move.each_key {|key|
			if @avail_move[key] == true	# �p�Y�������ւ��Ĕ�r
				puzzledisp()
				zeropos = @puzzle.index(0)									# ���Ƃ���0���������ꏊ���L��
				case key
					when '��'
						pos = -4
					when '��'
						pos = 4
					when '�E'
						pos = 1
					when '��'
						pos = -1
				end
				printf("�󗓏��%d�Ɠ���ւ�\n", @puzzle[zeropos + pos])
				@puzzle[zeropos] = @puzzle[zeropos + pos]	# 0�̈ʒu�Ɉړ���̃s�[�X��
				@puzzle[zeropos + pos] = 0									# ��0�̐^���0��
				if answer_search() == true
					print("��r���ʁF����\n")
					return
				else 
					print("��r���ʁF���s\n")
					# �ċN����
					# �������ݗ\��n
				end
			end
			@puzzle = @puzzle_initialstate	# ��r���ɕω��������p�Y����������Ԃɖ߂�
		}
	end

	def n_step1(result, repnum)	## ��߂�h�~�Ȃ��J��Ԃ��Bresult:�����܂ł̓��̂�Arepnum�F�[���̏��
				
		if repnum <= 0
			print("��蒼��\n\n")
			result.pop	# �s�����̓��̂�Ȃ̂ŏ���
			@puzzle = @puzzle_prev.dup	# ��r���ɕω��������p�Y����1�O�̏�Ԃɖ߂�
			#repnum = 2	# �[���̏�������̏�Ԃɖ߂�
			#print("puzzle������", @puzzle, "\n")
			return false	# 0�ȉ��Ȃ�Ⴄ�}��T��
		else
			availablemoving()	# �t���O�X�V
			@avail_move.each_key {|key|
				#print(key, "\n")
				if @avail_move[key] == true	# �p�Y�������ւ��Ĕ�r
					puzzledisp()			# �p�Y���\��
					zeropos = @puzzle.index(0)		# ���Ƃ���0���������ꏊ���L��
					@puzzle_prev = @puzzle.dup	# ���݂̏�Ԃ�ۑ��i�ω���1�O�̏�Ԃ�ێ��j
					case key
					when '��'
						printf("�󗓏��%d�Ɠ���ւ�\n", @puzzle[zeropos - 4])
						@puzzle[zeropos] = @puzzle[zeropos - 4]	# 0�̈ʒu�Ɉړ���̃s�[�X��
						@puzzle[zeropos - 4] = 0					# ��0�̐^���0��
						if answer_search() == true
							result.push(key)
							return true
						else 	# ���s�Ȃ�ċN����
							result.push(key)
							# �ċN����
							print("�c��ړ��񐔁F", repnum, "\n\n")
							if n_step1(result, repnum-1) == true
								return true
							end
						end
					when '��'
						printf("�󗓉���%d�Ɠ���ւ�\n", @puzzle[zeropos + 4])
						@puzzle[zeropos] = @puzzle[zeropos + 4]	# 0�̈ʒu�Ɉړ���̃s�[�X��
						@puzzle[zeropos + 4] = 0					# ��0�̐^���0��
						if answer_search() == true
							result.push(key)
							return true
						else 	# ���s�Ȃ�ċN����
							result.push(key)
							# �ċN����
							print("�c��ړ��񐔁F", repnum, "\n\n")
							if n_step1(result, repnum-1) == true
								return true
							end
						end
					when '�E'
						printf("�󗓉E��%d�Ɠ���ւ�\n", @puzzle[zeropos + 1])
						@puzzle[zeropos] = @puzzle[zeropos + 1]	# 0�̈ʒu�Ɉړ���̃s�[�X��
						@puzzle[zeropos + 1] = 0					# ��0�̐^���0��
						if answer_search() == true
							result.push(key)
							return true
						else 	# ���s�Ȃ�ċN����
							result.push(key)
							# �ċN����
							print("�c��ړ��񐔁F", repnum, "\n\n")
							if n_step1(result, repnum-1) == true
								return true
							end
						end
					when '��'
						printf("�󗓍���%d�Ɠ���ւ�\n", @puzzle[zeropos - 1])
						@puzzle[zeropos] = @puzzle[zeropos - 1]	# 0�̈ʒu�Ɉړ���̃s�[�X��
						@puzzle[zeropos - 1] = 0					# ��0�̐^���0��
						if answer_search() == true
							result.push(key)
							return true
						else 	# ���s�Ȃ�ċN����
							result.push(key)
							# �ċN����
							print("�c��ړ��񐔁F", repnum, "\n\n")
							if n_step1(result, repnum-1) == true
								return true
							end
						end
					end
				end
			}
		end
		result.pop	# �s�����̓��̂�Ȃ̂ŏ���
		print("�s�\�ȓ��̂�Ȃ̂Ń��Z�b�g\n\n")
		@puzzle = @puzzle_initialstate.dup	# ��r���ɕω��������p�Y�������̏�Ԃɖ߂�
		return false	# 0�ȉ��Ȃ�Ⴄ�}��T��
	end
end


## --------- ���ۂ̏����i���C���j ------------- ##
print("�v�f��16�̈ꎟ���z��̂ǂ�����0��}�����܂��B\n")
print("���̌�A�ړ��\�ꏊ��\�����܂��BEnter�������Ă�������\n")
prease_enter = gets	# Enter�������ƈȉ������s


fp = FifteenPuzzle.new	# �N���X������

# fp.zeroinsert_auto
fp.zeroinsert_manual
fp.puzzledisp
fp.positiondisp	# �󗓂̏ꏊ�ƈړ��\�ꏊ��\��

print("���̔Ֆʂ����������肵�܂��BEnter�������Ă�������\n")
prease_enter = gets	# Enter�������ƈȉ������s

deep = 2	# �[���̏��

result = Array.new	# �����܂ł̓��̂�

if fp.answer_search == true
	print("���茋�ʁF����\n")
else
	print("���茋�ʁF���s\n")
	print("�����Ĕ����[���@�Ő����ɂȂ邩�ǂ������肵�܂��B\n")
	print("�[���̏��", deep, "\n")
	if fp.n_step1(result, deep) == true
		print("�ŏI���茋�ʁF����\n")
		print("�����܂ł̓��̂�F", result)
	else
		print("�ŏI���茋�ʁF���s\n")
	end
end

