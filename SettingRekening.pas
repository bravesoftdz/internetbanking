unit SettingRekening;
{Unit yang mengelola pembuatan, perubahan data, dan penutupan rekening}
{ 	NOTE: 	kurang penutupan rekening }

interface
	
	uses
		DataTypes, dateandtime;

	procedure login(username, password : string; var indexNasabah : integer; var nomorNasabah : string; var isLogin : boolean; userTerdaftar : dataNasabah);
	procedure pembuatanRekening(rekeningTerdaftar: dataRekening; nomorNasabah : string; jenisRekening : string; 
								var isSuccess : boolean);
	procedure perubahanDataNasabah(nasabahTerdaftar : dataNasabah; indexNasabah : integer);
	//procedure penutupanRekening();


implementation

	procedure login(username, password : string; var indexNasabah : integer; var nomorNasabah : string; var isLogin : boolean; userTerdaftar : dataNasabah);
	//Fungsi Prosedur : Mengevaluasi masukan username dan password dari pengguna
	//Prosedur ini hanya mengevaluasi masukan username dan password, untuk pengulangan masukan
	//haruslah dilakukan pada program utama
	var
		i : integer;

	begin
		isLogin := False;
		counter := 3;
		for i := 1 to userTerdaftar.jumlahData do begin
			if (userTerdaftar.data[i].username = username) and (userTerdaftar.data[i].password = password) then begin
				isLogin := True;
				nomorNasabah := nomor;
				indexNasabah := i;
			end
			else begin
				counter := counter - 1;
				writeln('Username atau password tidak tepat. Silahkan coba lagi. Anda masih memiliki ', counter, ' kesempatan');
			end;
		end; 
		//Jika username dan password tidak pernah tepat, maka akun yang dinonaktifkan (?)
		//if (counter = 0) then 
	end;


	procedure pembuatanRekening(rekeningTerdaftar: dataRekening; nomorNasabah : string; jenisRekening : string; 
								var isSuccess : boolean);

	var
		index : integer;
	begin
		isSuccess := False;
		index := rekeningTerdaftar.indexTerakhir + 1;
		if (jenisRekening = 'tabungan mandiri') then
		begin
			rekeningTerdaftar.data[index].jenisRekening := jenisRekening;
			rekeningTerdaftar.data[index].mataUang := 'IDR';
			repeat 
				write('Saldo awal: ');
				readln(rekeningTerdaftar.data[index].saldo);
			until (rekeningTerdaftar.data[index].saldo >= 500000);
		end
		else if (jenisRekening = 'deposito') then
		begin
			rekeningTerdaftar.data[index].jenisRekening := jenisRekening;
			repeat
				write('Mata uang: (IDR|USD|EUR)');
				readln(rekeningTerdaftar.data[index].mataUang);
				if (rekeningTerdaftar.data[index].mataUang <> 'IDR') or (rekeningTerdaftar.data[index].mataUang <> 'USD')
					or (rekeningTerdaftar.data[index].mataUang <> 'EUR') then begin
					writeln('Tolong cek kembali masukan anda');
				end;
			until (rekeningTerdaftar.data[index].mataUang = 'IDR') or (rekeningTerdaftar.data[index].mataUang = 'USD')
					or (rekeningTerdaftar.data[index].mataUang = 'EUR');
			if (rekeningTerdaftar.data[index].mataUang = 'IDR') then begin
				repeat
					write('Setoran awal (Minimal setoran 8000000): ');
					readln(rekeningTerdaftar.data[index].saldo);
					if (rekeningTerdaftar.data[index].saldo < 8000000) then 
						writeln('Setoran awal harus lebih besar dari 80000000');
				until (rekeningTerdaftar.data[index].saldo >= 8000000);
			end
			else if (rekeningTerdaftar.data[index].mataUang = 'USD') then begin
				repeat
					write('Setoran awal (Minimal setoran 600): ');
					readln(rekeningTerdaftar.data[index].saldo);
					if (rekeningTerdaftar.data[index].saldo < 600) then 
						writeln('Setoran awal harus lebih besar dari 600');
				until (rekeningTerdaftar.data[index].saldo >= 600);
			end
			else if (rekeningTerdaftar.data[index].mataUang = 'EUR') then begin
				repeat
					write('Setoran awal (Minimal setoran 550): ');
					readln(rekeningTerdaftar.data[index].saldo);
					if (rekeningTerdaftar.data[index].saldo < 550) then
						writeln('Setoran awal harus lebih besar dari 550');
				until (rekeningTerdaftar.data[index].saldo >= 550);
			end;
			repeat
				write('Jangka waktu deposito (bulan): ');
				readln(rekeningTerdaftar.data[index].jangkaWaktu);
			until (rekeningTerdaftar.data[index].jangkaWaktu = 1) or (rekeningTerdaftar.data[index].jangkaWaktu = 3) or 
				(rekeningTerdaftar.data[index].jangkaWaktu = 6) or (rekeningTerdaftar.data[index].jangkaWaktu = 12);
		end
		else if (jenisRekening = 'tabungan rencana') then begin
			rekeningTerdaftar.data[index].jenisRekening := jenisRekening;
			rekeningTerdaftar.data[index].mataUang := 'IDR';
			repeat
				write('Setoran awal: ');
				readln(rekeningTerdaftar.data[index].saldo);
				if (rekeningTerdaftar.data[index].saldo < 0) then
					writeln('Tolong cek masukan anda');
			until (rekeningTerdaftar.data[index].saldo >= 0);
			repeat
				write('Setoran rutin (Minimal 500000): ');
				readln(rekeningTerdaftar.data[index].setoranRutin);
				if (rekeningTerdaftar.data[index].setoranRutin < 500000) then 
					writeln('Setoran rutin minimal 500000 rupiah');
			until (rekeningTerdaftar.data[index].setoranRutin >= 500000);
			repeat
				write('Jangka waktu tabungan rencana (tahun): ');
				readln(rekeningTerdaftar.data[index].jangkaWaktu);
			until (rekeningTerdaftar.data[index].jangkaWaktu >= 1) and (rekeningTerdaftar.data[index].jangkaWaktu <= 20);
		end
		else begin
			writeln('Tolong cek masukan anda');
		end;
	end;


	procedure perubahanDataNasabah(nasabahTerdaftar : dataNasabah; indexNasabah : integer);

	var
		pilihanValid : boolean;
		pilihanNasabah : string;
	begin
		writeln('Data nasabah saat ini: ');
		writeln('Nama: ', nasabahTerdaftar.data[indexNasabah].nama);
		writeln('Alamat: ', nasabahTerdaftar.data[indexNasabah].alamat);
		writeln('Kota: ', nasabahTerdaftar.data[indexNasabah].kota);
		writeln('Email: ', nasabahTerdaftar.data[indexNasabah].email);
		writeln('Nomor telefon: ', nasabahTerdaftar.data[indexNasabah].nomorTelefon);
		writeln('Status: ', nasabahTerdaftar.data[indexNasabah].status);
		write('Apakah anda tetap ingin mengganti data anda? (Y/N)');
		readln(pilihanNasabah);
		if (pilihanNasabah = 'Y') then begin
			repeat
				writeln('Data yang ingin diubah: (contoh: Ketik "Nama" untuk merubah nama)');
				write('Untuk megubah password, ketik "password');
				readln(pilihanNasabah);
					if (pilihanNasabah = 'Nama') then begin
						pilihanValid := True;
						write('Nama baru: ');
						readln(nasabahTerdaftar.data[indexNasabah].nama);
						writeln('Data nama anda telah sukses diganti');
					end
					else if (pilihanNasabah = 'Alamat') then begin
						pilihanValid := True;
						write('Alamat baru: ');
						readln(nasabahTerdaftar.data[indexNasabah].alamat);
						writeln('Data alamat anda telah sukses diganti');				
					end
					else if (pilihanNasabah = 'Kota') then begin
						pilihanValid := True;
						write('Kota: ');
						readln(nasabahTerdaftar.data[indexNasabah].kota);
						writeln('Data kota email anda telah sukses diganti');				
					end
					else if (pilihanNasabah = 'Email') then begin
						pilihanValid := True;
						write('Email: ');
						readln(nasabahTerdaftar.data[indexNasabah].email);
						writeln('Data email anda telah sukses diganti');				
					end
					else if (pilihanNasabah = 'Nomor telefon') then begin
						pilihanValid := True;
						write('Nomor telefon: ');
						readln(nasabahTerdaftar.data[indexNasabah].nomorTelefon);
						writeln('Data nomor telefon anda telah sukses diganti');				
					end
					else
						pilihanValid := False;
			until (pilihanValid);
		end
		else
			writeln('Perubahan dibatalkan'); 
	end;


end.