/* Algoritmul de sortare shellsort implementat in C
void shell(unsigned long n, float a[])
{
	unsigned long i, j, inc;
	float v;
	inc = 1;
		do 
		{
			inc *= 3;
			inc++;
		} while (inc <= n);
		
		do 
		{
			inc /= 3;
			for (i = inc + 1; i <= n; i++) 
			{
				v = a[i];
				j = i;
				
				while (a[j - inc] > v) 
				{
					printf("\n\n%d\n", j);
					a[j] = a[j - inc];
					j -= inc;	
					//printf("\n\n%d\n", j);
					if (j <= inc) break;
				}
				a[j] = v;
			}
		} while (inc > 1);
}
int main()
{
	float a[8] = { 511,144,16,68,5,2 };
	shell(5, a);

	for (int i = 1; i <= 5; i++)
	{
		printf("%f\n", a[i]);
	}
	return 0;
}
*/

.global _start
.extern write_str
.extern write_byte
.func shell_sort

.data
.balign 4
afisare_inainte:    .asciz "\nElementele vectorului nesortat sunt:\r\n\n"
afisare_dupa:    	.asciz "\nElementele vectorului sortat sunt:\r\n\n"
nr_elemente: 		.word 8
new_line:			.asciz "\r\n"

.text
_start:
    	LDR 	SP, =stack_top	//initializare pointer stiva

		MOV		r3,#10			//initializare r3 cu adresa de la care pun elementele vectorului(10)

		//punere elemente vector in memorie din 10 in 10, incepand de la adresa 10
		MOV 	r2,#5			//r2 = elementul pe care vreau sa-l introduc
		STR		r2,[r3]			//la adresa cu valoarea r3 il stochez pe r2
		ADD		r3,r3,#10		//r3 = r3 + 10
		MOV 	r2,#68				
		STR		r2,[r3]
		ADD		r3,r3,#10
		MOV 	r2,#16			
		STR		r2,[r3]
		ADD		r3,r3,#10
		MOV 	r2,#144			
		STR		r2,[r3]
		ADD		r3,r3,#10
		MOV 	r2,#2			
		STR		r2,[r3]
		ADD		r3,r3,#10
		MOV 	r2,#27			
		STR		r2,[r3]
		ADD		r3,r3,#10
		MOV 	r2,#200			
		STR		r2,[r3]
		ADD		r3,r3,#10
		MOV 	r2,#83			
		STR		r2,[r3]
		
		//r7 = nr.elemente (n)
		LDR		r7, =nr_elemente //load adresa variabilei nr_elemente in r7
		LDR		r7,[r7]			//load valoare variabila nr_elemente in r7
		MOV		r8,#1			//r8 = inc = 1
		MOV		r9,#3			//r9 = 3

		LDR		r0, =afisare_inainte  //load adresa string afisare_inainte in r0
		BL 		write_str		//afisare mesaj
		BL 		afisare			//apelez functia de afisare de elemente

    	BL 		shell_sort		//apelez functia de sortare

		LDR		r0, =afisare_dupa	//load adresa string afisare_dupa in r0
		BL 		write_str		//afisare mesaj
		BL		afisare			//apelez functia de afisare de elemente, dupa sortare
	    B . 


shell_sort:
 		push 	{lr} 			//push adresa de return pe stiva
 		
calcul_inc:						//bucla de calcul a incrementului(inc)
		MOV		r0,r8			//r0 = r8 = inc
		MUL		r8,r0,r9		//inc = inc * 3
		ADD		r8,r8,#1		//inc = inc + 1
		CMP 	r8,r7			//compar inc cu nr. de elemente(r8 cu r7)
		BLE		calcul_inc		//daca inc <= n atunci se reia bucla de calcul a incrementului
		
		//dupa calcul_inc, r8 = valoarea incrementului calculata anterior

loop:	MOV		r1,r8			//r1 = r8 = inc
		MOV		r2,#0			//r2 = 0
inc_div3:						//bucla calcul inc(inc = inc/3) pentru fiecare trecere prin loop
								//inc = inc/3
		ADD		r2,r2,#1		//r2++
		SUB		r1,r1,#3		//r1=r1-3
		CMP		r1,#2			//compar inc cu 2
		BGT		inc_div3		//daca r1(inc) > 2 atunci se reia bucla inc_div3(adica daca restul impartirii >2)
		MOV		r8,r2 			//r8 = noul inc(adica vechiul inc / 3)
		
		ADD		r2,r2,#1		//r2 = r2 + 1(r2 = i = inc + 1)
for_inc:
		//for (i = inc + 1; i <= n; i++)
		CMP		r2,r7			//compar i cu n - nr. de elemente
		BGT		end_for_inc		//cat timp e mai mic sau egal se executa bucla, altfel se sare la end_for_inc(se termina bucla for)

		//convertesc valoarea lui inc intr-o valoare valida de memorie(o inmultesc cu 10, deoarece am pus elementele in memorie din 10 in 10)
		MOV		r4,#10			//r4 = 10
		MUL		r4,r2,r4		//r4 = i*10(deoarece am pus elementele in memorie din 10 in 10)
		LDR		r6,[r4]			//v = a[i] (r6 = v)
		MOV 	r9,r4			//j = i (r9 = j)
		
		
while_in:
		//while (a[j - inc] > v) 
		MOV 	r12,#10			//calculez j - inc, dar tot cu adrese de memorie(luate din 10 in 10) ; r12 = 10
		MUL		r12,r8,r12		//r12 = inc * 10
		SUB		r10,r9,r12		//r10 = j-inc

		
		LDR		r11,[r10]		//r11 = a[j-inc](load din memorie pe nr. aflat la adresa j-inc)
		CMP		r11,r6			//compar a[j-inc] cu v(adica a[i])	
		BLE		end_while_in	//daca a[j-inc] > a[i], atunci se reia bucla while_in, altfel se termina

		STR		r11,[r9]		//a[j] = a[j-inc] (store in memorie la adresa j pe elementul a[j-inc])	
		SUB 	r9,r9,r12		//j = j-inc
		
		CMP		r9,r12			//compar j cu inc
		BLE		end_while_in	//daca j <= inc(inc*10), merg la end_while_in si se termina bucla
		B		while_in		//altfel se reia bucla while_in
end_while_in:

		STR		r6,[r9]			//la adresa j se stocheaza valoarea r6 (adica a[j] = v) 
		ADD		r2,r2,#1		//i=i+1
		B		for_inc			//salt la for_inc
end_for_inc:

		CMP 	r8,#1			//compar r8 cu 1
		BGT		loop			//daca r8 > 1 (adica inc > 1) se reia loop -> bucla do...while din algoritm

 		pop		{lr}			//pop adresa de return de pe stiva
 		BX 		lr				//salt la lr

afisare:
		//afisare elemente vector
		push 	{lr}			//push adresa de return pe stiva
		MOV		r4,#0			//r4=0(r4 - adresa de memorie)
		MOV		r5,#0			//r5=0(r5 - contor)

afisare_l:
		//bucla de afisare a elementelor
		ADD		r4,r4,#10		//incrementez adresa cu 10
		LDR		r0,[r4]			//r0 = elementul de la adresa r4 din memorie
		BL 		write_byte		//afisare element din vector
		LDR		r0, =new_line	//r0 = linie noua
		BL		write_str		//afisare linie noua(\n)
		ADD		r5,r5,#1		//r5 = r5 + 1
		CMP		r5,r7			//compar contorul cu nr. de elemente din vector(r7 - n -> nr. de elemente din vector)
		BLT		afisare_l		//daca contor < n se reia bucla de afisare(se afiseaza un nou element)

		pop		{lr}			//pop adresa de return de pe stiva
 		BX 		lr				//salt la lr


