# DANG THANH ANH
# Bai tap lon Kien truc may tinh
# merge sort
.data
str1: .asciiz "\nNhap vao mang 50 phan tu so nguyen can mergeSort:\n"
str2: .asciiz "\nMang 50 so nguyen ban dau:\n"
str3: .asciiz "Array: ["
str4: .asciiz " , "
str5: .asciiz "]\n"
str6: .asciiz "\nMang sau khi thuc hien mergesort:\n"
array: .word 0:100
.text
main:
	la $a0, str1 #in ra str1
	ori $v0,$0, 4
	syscall
	addi $t0, $0, 50   # so phan tu cua mang
	addi $t1, $0, 0    # bien chay for i
	la $a1, array	   # dia chi mang arr[0]
for:			# chay vong lap nhap vao mang so nguyen 50 phan tu
	beq $t1, $t0, end	
	ori $v0, $0, 5
	syscall
	sw $v0, ($a1)  # dua phan tu nhap vao array
	addi $a1, $a1, 4
	addi $t1, $t1, 1
	j for
end:	
	la $a2, str2
	jal print     # goi ham de print array ban dau
	
	la $a0, array # dia chi cua phan tu dau array
	sll $t1, $t0, 2   # nhan length voi kich thuc phan tu la 4
	add $a1, $a0, $t1 # dia chi cua phan tu cuoi array
	jal mergeSort    #goi ham mergesort
	
	la $a2, str6
	jal print     # goi ham de print array sau khi mergeSort
	ori $v0, $0 ,10  # ket thuc chuong trinh
	syscall
#
# MergeSort MIPS
mergeSort:
	addi $sp, $sp, -16 # dieu chinh con tro cua ngan xep
	sw $ra, 0($sp) # luu dia chi tra ve vao ngan xep
	sw $a0, 4($sp) # luu dia chi phan tu dau tien cua mang vao ngan xep
	sw $a1, 8($sp) # luu dia chi phan tu cuoi cua mang vao ngan xep
	sub $t1, $a1, $a0 # end - begin
	ori $t7,$0, 4    
	slt $at,$t7, $t1
	beq $at, $zero, mSEnd #Neu co <= 1 phan tu thi return
	srl $t1,$t1,3     # 1/2 so phan tu cua mang
	sll $t1, $t1,2    # dia chi cua phan tu o giua
	add $a1, $a0,$t1 # dua dia chi giua thanh dia chi cuoi khi goi lai ham mergesort
	sw $a1, 12($sp) # luu dia chi giua vao ngan sep 
	jal mergeSort # goi de quy mergesort voi nua dau cua mang
	
	lw $a0 , 12($sp) # cap nhat dia chi dau cua nua mang sau
	lw $a1, 8($sp)   #  cap nhat dia chi cuoi cua nua mang sau
	jal mergeSort # goi de quy mergesort voi nua mang cuoi
	
	lw $a0, 4($sp) #cap nhat lai dia chi dau cua mang
	lw $a1, 12($sp) # cap nhat lai dia chi giua cua mang
	lw $a2, 8($sp) # cap nhat lai dia chi cuoi cua mang
	jal merge	#goi ham merge
	
mSEnd:
	lw  $ra, 0($sp)	  #lay dia chi tra ve da duoc luu tu truoc
	addi $sp, $sp,16 # giai phong con tro
	jr $ra		# return      ket thu ham mergesort
	
merge:                #Ham merge
	addi $sp, $sp,-16 # dieu chi con tro cua ngan sep
	sw $ra, 0($sp) #luu dia chi tra ve vao ngan sep
	sw $a0, 4($sp) # luu dia chi cua phan  tu dau tien trong mang
	sw $a1, 8($sp) # luu dia chi cua phan tu giua mang
	sw $a2, 12($sp) #luu phan tu cua phan tu cuoi mang
	add $s0,$a0, $0   #dia chi dau
	add $s1 $a1, $0   #dia chi cuoi
while:  
	lw $t2, 0($s0) #gia tri cua phan tu dau
	lw $t3, 0($s1) # gia tri cua phan tu cuoi
	slt $t4, $t2,$t3   #if($t3 > $t2) break;
	bne $t4, $0 , donot
	add $a0, $s1,$0 # nap gia tri $a0 cua ham swap
	add $a1, $s0,$0 # nap gia tri $a1 cua ham swap
	jal change # goi ham change
	addi $s1 , $s1, 4   #tang dia chi len 1 phan tu
donot:
	addi $s0, $s0, 4    #tang dia chi len 1 phan tu
	lw $a2, 12($sp)     # gia tri phan tu o giua
	slt $at, $s0, $a2        # phan tu duyet vuot qua phan tu giua ket thuc vong lap
	beq $at, $0 , endwhile
	slt $at, $s1, $a2
	beq $at, $0 , endwhile
	j while     #goi vong lap
	
endwhile:
 	lw $ra, 0($sp)    #lay dia chi tra ve
 	addi $sp, $sp, 16 # giai phong con tro
 	jr $ra             #return
#Ham change chuyen phan tu mang sang vi tri khac, o dia chi thap hon 
#
#  $a0 la dia chi cua phan tu can hoan doi
#  $a1 la dia chi dich
change: 
	ori $t0, $0, 50 #so phan tu cua mang
	slt $at, $a1, $a0 
	beq $at, $0, changeEnd #neu da dung vi tri khong can thuc hien 
	addi $t5, $a0, -4	#dia chi cua phan tu truoc do
	lw $t6, 0($a0)   # move cac gia tri
	lw $t7, 0($t5)
	sw $t6, 0($t5)
	sw $t7, 0($a0)
	addi $a0, $a0,-4    # gia dia chi array cua phan tu dang xet
	j change
changeEnd:
	jr $ra   #return

print:			#ham print array
	add $a0, $a2,$0	    # print ra str tai dai chi cua $a2
	ori $v0,$0, 4
	syscall
	la $a0, str3	# print "Array: ["
	ori $v0,$0, 4
	syscall
	addi $t1, $0, 0 # phan tu i
	la $a1, array   # dia chi cua arr[0]
whileprint:			#Vong lap print ra tung phan tu cua array
	beq $t1, $t0, printEnd  # if(i == n) printEnd
	lw $a0, ($a1)
	ori $v0,$0, 1
	syscall
	beq $t1, 49, L1 # tai phan tu length -1 
	la $a0, str4   # print " , "    if(i<n) cout<< " , ";
	ori $v0,$0, 4
	syscall
L1:
	addi $a1, $a1, 4    #tang dia chi array len 1 phan tu
	addi $t1,$t1,1	     # i++
	j whileprint
printEnd:
	la $a0, str5     # print "]/n"
	ori $v0,$0, 4
	syscall
	jr $ra
	
