unit Transaction;
{Mengelola fitur transaksi pada akun rekening}

{NOTE: kurang penambahanAutoDebet
	masih banyak compile error
}

interface
	uses
		DataTypes, dateandtime;

	function validTabunganRencana(dayNow, monthNow, yearNow, dayBase, monthBase, yearBase : word;
									jangkaWaktu : word) : boolean;
	function validDeposito(dayNow, monthNow, yearNow, dayBase, monthBase, yearBase : word;
							jangkaWaktu : word) : boolean;
	procedure setoran();
	procedure penarikan();
	procedure transfer();
	procedure pembayaran();
	procedure pembelian();
	//procedure penambahanAutoDebet(); {belum ada}

implementation
	
	function validTabunganRencana(dayNow, monthNow, yearNow, dayBase, monthBase, yearBase : word;
									jangkaWaktu : word) : boolean;

	begin
		if (dayNow >= dayBase) and (monthNow >= monthBase) then 
			validTabunganRencana := (yearNow - yearBase) >= jangkaWaktu
		else validTabunganRencana := (yearNow - yearBase) > jangkaWaktu; 
	end;

	function validDeposito(dayNow, monthNow, yearNow, dayBase, monthBase, yearBase : word;
							jangkaWaktu : word) : boolean;

	begin
		if (dayNow >= dayBase) then validDeposito := (monthNow - monthBase) >= jangkaWaktu
		else validDeposito := (monthNow - monthBase) > jangkaWaktu;
	end;


	procedure setoran(rekeningTerdaftar : dataRekening; nomorNasabah : string; var transaksiReceipt : dataTransaksi);
	
	var
		isFound : boolean;
		nomorAkun : string;
		jumlahSetoran : longint;
		i, index: integer;

	begin
		isFound := False;
		index := transaksiReceipt.indexTerakhir + 1;
		repeat
			write('Nomor rekening: ');
			readln(nomorAkun);
			for i := 1 to rekeningTerdaftar.jumlahData do
			begin
				if  (rekeningTerdaftar.data[i].nomorAkun = nomorAkun) and 
					(rekeningTerdaftar.data[i].nomorNasabah = nomorNasabah) then
				begin
					writeln('Saldo sekarang: ', rekeningTerdaftar.data[i].saldo);
					repeat
						write('Jumlah setoran: ');
						readln(jumlahSetoran);
						if (jumlahSetoran < 0) then 
							writeln('Tolong cek kembali masukan anda');
					until (jumlahSetoran >= 0);
					rekeningTerdaftar.data[i].saldo := rekeningTerdaftar.data[i].saldo + jumlahSetoran;
					isFound := True;
					writeln('Saldo sekarang: ', rekeningTerdaftar.data[i].saldo);
					
					transaksiReceipt.data[index].nomorAkun := rekeningTerdaftar.data[i].nomorAkun;
					transaksiReceipt.data[index].jenisTransaksi := 'setoran';
					transaksiReceipt.data[index].mataUang := rekeningTerdaftar.data[i].mataUang;
					transaksiReceipt.data[index].jumlah := jumlahSetoran;
					transaksiReceipt.data[index].saldo := transaksiReceipt.data[i].saldo;
					getDateString(transaksiReceipt.data[index].tanggalTransaksi);
				end;
			end;
			if not(isFound) then 
				writeln('Nomor rekening tidak ditemukan');
		until (isFound);
	end;


	procedure penarikan(rekeningTerdaftar : dataRekening; transaksiReceipt : dataTransaksi; nomorNasabah : string);
	
	var
		isFound, isValidTransaction : boolean;
		nomorAkun : string;
		jumlahPenarikan : longint;
		i : integer;
		day, wday, year, month : word;
		dayNow, yearNow, monthNow : word;
		index : integer;

	begin
		isFound := False;
		index := transaksiReceipt.indexTerakhir + 1;
		repeat
			write('Nomor rekening: ');
			readln(nomorAkun);
			for i := 1 to rekeningTerdaftar.jumlahData do begin
				if (rekeningTerdaftar.data[i].nomorAkun = nomorAkun) and 
					(rekeningTerdaftar.data[i].nomorNasabah = nomorNasabah) then begin
					if (rekeningTerdaftar.data[i].jenisRekening = 'tabungan mandiri') then begin
						writeln('Saldo sekarang: ', rekeningTerdaftar.data[i].saldo);
						repeat
							write('Jumlah penarikan: ');
							readln(jumlahPenarikan);
							if (rekeningTerdaftar.data[i].saldo < jumlahPenarikan) then 
								writeln('Tolong cek kembali masukan anda');
						until (rekeningTerdaftar.data[i].saldo >= jumlahPenarikan);
						rekeningTerdaftar.data[i].saldo := rekeningTerdaftar.data[i].saldo - jumlahPenarikan;
						isFound := True;
						writeln('Saldo sekarang: ', rekeningTerdaftar.data[i].saldo);

						transaksiReceipt.data[index].nomorAkun := rekeningTerdaftar.data[i].nomorAkun;
						transaksiReceipt.data[index].jenisTransaksi := 'penarikan';
						transaksiReceipt.data[index].mataUang := rekeningTerdaftar.data[i].mataUang;
						transaksiReceipt.data[index].jumlah := jumlahPenarikan;
						transaksiReceipt.data[index].saldo := transaksiReceipt.data[i].saldo;
						getDateString(transaksiReceipt.data[index].tanggalTransaksi);
					end
					else if (rekeningTerdaftar.data[i].jenisRekening = 'deposito') then begin
						GetDate(year,month,day,wday);
						turnDateToInt(dayNow, monthNow, yearNow, rekeningTerdaftar.data[i].tanggalMulai);
						isValidTransaction := validDeposito(dayNow, monthNow, yearNow, day, month, year,
															rekeningTerdaftar.data[i].jangkaWaktu);
						if (isValidTransaction) then begin
							writeln('Saldo sekarang: ', rekeningTerdaftar.data[i].saldo);
							repeat
								write('Jumlah penarikan: ');
								readln(jumlahPenarikan);
								if (rekeningTerdaftar.data[i].saldo < jumlahPenarikan) then 
									writeln('Tolong cek kembali masukan anda');
							until (rekeningTerdaftar.data[i].saldo >= jumlahPenarikan);
							rekeningTerdaftar.data[i].saldo := rekeningTerdaftar.data[i].saldo - jumlahPenarikan;
							isFound := True;
							writeln('Saldo sekarang: ', rekeningTerdaftar.data[i].saldo);
							transaksiReceipt.data[index].nomorAkun := rekeningTerdaftar.data[i].nomorAkun;
							transaksiReceipt.data[index].jenisTransaksi := 'penarikan';
							transaksiReceipt.data[index].mataUang := rekeningTerdaftar.data[i].mataUang;
							transaksiReceipt.data[index].jumlah := jumlahPenarikan;
							transaksiReceipt.data[index].saldo := transaksiReceipt.data[i].saldo;
							getDateString(transaksiReceipt.data[index].tanggalTransaksi);					
						end
						else writeln('Maaf penarikan tidak dapat dilakukan selama masih di dalam jangka waktu yang ditentukan')
					end
					else begin
						GetDate(year,month,day,wday);
						turnDateToInt(dayNow, monthNow, yearNow, rekeningTerdaftar.data[i].tanggalMulai);
						isValidTransaction := validTabunganRencana(dayNow, monthNow, yearNow, day, month, year,
																	rekeningTerdaftar.data[i].jangkaWaktu);
						if (isValidTransaction) then begin
							writeln('Saldo sekarang: ', rekeningTerdaftar.data[i].saldo);
							repeat
								write('Jumlah penarikan: ');
								readln(jumlahPenarikan);
								if (rekeningTerdaftar.data[i].saldo < jumlahPenarikan) then 
									writeln('Tolong cek kembali masukan anda');
							until (rekeningTerdaftar.data[i].saldo >= jumlahPenarikan);
							rekeningTerdaftar.data[i].saldo := rekeningTerdaftar.data[i].saldo - jumlahPenarikan;
							isFound := True;
							writeln('Saldo sekarang: ', rekeningTerdaftar.data[i].saldo);			
							transaksiReceipt.data[index].nomorAkun := rekeningTerdaftar.data[i].nomorAkun;
							transaksiReceipt.data[index].jenisTransaksi := 'penarikan';
							transaksiReceipt.data[index].mataUang := rekeningTerdaftar.data[i].mataUang;
							transaksiReceipt.data[index].jumlah := jumlahPenarikan;
							transaksiReceipt.data[index].saldo := transaksiReceipt.data[i].saldo;
							getDateString(transaksiReceipt.data[index].tanggalTransaksi);		
							transaksiReceipt.indexTerakhir := transaksiReceipt.indexTerakhir + 1;
						end
						else writeln('Maaf penarikan tidak dapat dilakukan selama masih di dalam jangka waktu yang ditentukan')
					end
				end;
			end;
			if not(isFound) then 
				writeln('Nomor rekening tidak ditemukan');
		until (isFound);
	end;


	procedure transfer(rekeningTerdaftar : dataRekening; nomorNasabah : string; transaksiReceipt : dataTransaksiTransfer);
	
	var
		noRekeningPengirim, noRekeningPenerima : string;
		rekPengirimValid : boolean;
		rekPenerimaValid : boolean;
		penerimaBankSama : boolean = False;
		i, j : integer;
		day, wday, year, month : word;
		index : integer;
		dayNow, yearNow, monthNow : word;
		biayaTransfer : longint;
		mataUangRekPenerima : string;
		jumlahTransfer : longint;
		konfirmasi : char;
		pilihanTransaksi : char;
		jenisTransaksi : string;
		namaBank : string;

	begin
		write('Nomor rekening yang akan dipakai untuk mentransfer: ');
		readln(noRekeningPengirim);
		index := transaksiReceipt.indexTerakhir + 1;
		for i := 1 to rekeningTerdaftar.jumlahData do
		begin
			GetDate(year,month,day,wday);
			turnDateToInt(dayNow, monthNow, yearNow, rekeningTerdaftar.data[i].tanggalMulai);

			if (rekeningTerdaftar.data[i].nomorAkun = noRekeningPengirim) and 
				(rekeningTerdaftar.data[i].nomorNasabah = nomorNasabah) then begin

				if (rekeningTerdaftar.data[i].jenisRekening = 'deposito') then begin
					rekPengirimValid := validDeposito(dayNow, monthNow, yearNow, day, month, year,
														rekeningTerdaftar.data[i].jangkaWaktu);
				end
				else if (rekeningTerdaftar.data[i].jenisRekening = 'tabungan rencana') then begin
					rekPengirimValid := validTabunganRencana(dayNow, monthNow, yearNow, day, month, year,
														rekeningTerdaftar.data[i].jangkaWaktu);
				end
				else rekPengirimValid := True; 
				if (rekPengirimValid) then begin
					repeat
						readln(pilihanTransaksi);
						if (pilihanTransaksi = 'Y') then begin
							penerimaBankSama := True;
							jenisTransaksi := 'dalam bank';
						end
						else if (pilihanTransaksi = 'N') then begin
							penerimaBankSama := False;
							jenisTransaksi := 'antar bank';
							write('Nama mata bank: ');
							readln(namaBank);
						end;
					until (pilihanTransaksi = 'Y') or (pilihanTransaksi = 'N');
					write('Transaksi antar bank? (Y/N');
					//Cek apakah rekening penerima sama dengan pengirim
					if (noRekeningPenerima = noRekeningPengirim) then writeln('Rekening yang dituju tidak boleh sama dengan rekening penerima')
					else begin
						//Cek apakah rekening penerima ada pada database bank
						repeat
							write('Nomor rekening yang dituju: ');
							readln(noRekeningPenerima);
							for j := 1 to rekeningTerdaftar.jumlahData do begin
								if (noRekeningPenerima = rekeningTerdaftar.data[i].nomorAkun) then rekPenerimaValid := True;
							end;
							if not(rekPenerimaValid) then writeln('Rekening penerima tidak dapat ditemukan di data bank. Silahkan coba lagi');
						until (rekPenerimaValid);
						if (penerimaBankSama) then begin
							biayaTransfer := 0;
						end
						else begin
							repeat
								write('Mata uang rekening penerima (USD|EUR|IDR): ');
								readln(mataUangRekPenerima);
								if not ((mataUangRekPenerima = 'USD') or (mataUangRekPenerima = 'EUR') or (mataUangRekPenerima = 'IDR')) then begin
									writeln('Masukan mata uang harus berupa USD atau EUR atau IDR. Silahkan coba lagi')
								end;
							until (mataUangRekPenerima = 'USD') or (mataUangRekPenerima = 'EUR') or (mataUangRekPenerima = 'IDR'); 
							case (mataUangRekPenerima) of
								'IDR' : biayaTransfer := 5000;
								'USD' : biayaTransfer := 2*usdToIDR;
								'EUR' : biayaTransfer := 2*eurToIDR;
							end;
							case (rekeningTerdaftar.data[i].mataUang) of
								'USD' : biayaTransfer := biayaTransfer div usdToIDR;
								'EUR' : biayaTransfer := biayaTransfer div eurToIDR;
							end;
							writeln('Saldo sekarang: ', rekeningTerdaftar.data[i].saldo);
							repeat
								write('Jumlah transfer: ');
								readln(jumlahTransfer);
								if (rekeningTerdaftar.data[i].saldo < jumlahTransfer + biayaTransfer) then 
									writeln('Saldo anda kurang');
							until (rekeningTerdaftar.data[i].saldo >= jumlahTransfer + biayaTransfer);
							writeln('Rekening pengirim: ', noRekeningPengirim);
							writeln('Rekening penerima: ', noRekeningPenerima);
							writeln('Jumlah transfer: ', jumlahTransfer);
							writeln('Biaya transfer: ', biayaTransfer);
							write('Lanjutkan transaksi? (Y/N)');
							readln(konfirmasi);
							if (konfirmasi = 'Y') then begin
								rekeningTerdaftar.data[i].saldo - jumlahTransfer;
								write('Transaksi ke ', noRekeningPenerima, ' sejumlah ', jumlahTransfer, ' berhasil');
								transaksiReceipt.data[index].nomorAkunAsal := noRekeningPengirim;
								transaksiReceipt.data[index].nomorAkunTujuan := noRekeningPenerima;
								transaksiReceipt.data[index].jenisTransfer := jenisTransfer;
								transaksiReceipt.data[index].mataUang := mataUangRekPenerima;
								transaksiReceipt.data[index].jumlah := jumlahTransfer;
								transaksiReceipt.data[index].saldo := transaksiReceipt.data[i].saldo;
								transaksiReceipt.data[index].tanggalTransaksi := getDateString();
								transaksiReceipt.indexTerakhir := transaksiReceipt.indexTerakhir + 1;
							end
							else then writeln('Transaksi dibatalkan');
						end;
					end;
				end
				else then writeln('Maaf rekening ', rekeningTerdaftar.data[i].jenisRekening, ' anda saat ini tidak dapat melakukan transaksi');
			end
			else begin
				writeln('Nomor rekening tidak ditemukan, silahkan cek kembali nomor rekening anda')
			end;
		end;
	end;


	procedure pembayaran();

	var
		pilihanPengguna : integer;
		day, date, month, year : word;

	begin
		writeln('List pembayaran: ');
		writeln('1. Pembayaran listrik');
		writeln('2. PDAM');
		writeln('3. Telepon');
		writeln('4. TV Kabel');
		writeln('5. Internet');
		writeln('6. Kartu Kredit');
		writeln('7. Pajak');
		writeln('8. Pendidikan');
		repeat
			write('Pilihan opsi pembayaran: ');
			readln(pilihanPengguna);
			if 	(pilihanPengguna = 1) or (pilihanPengguna = 2) or (pilihanPengguna = 3) or (pilihanPengguna = 4) or 
				(pilihanPengguna = 5) then
			begin
				GetDate(year,month,date,day);
				if (date >= 15) then
				begin
					//Bayar dengan harga normal
				end 
				else
				begin
					//Bayar dengan denda 10 ribu per hari
				end;
			end
			else if (pilihanPengguna = 6) or (pilihanPengguna = 7) or (pilihanPengguna = 8) then begin
				//Bayar sesuai tagihan
			end
			else writeln('Pastikan opsi tepat. Silahkan coba lagi');
		until (pilihanPengguna = 1) or (pilihanPengguna = 2) or (pilihanPengguna = 3) or (pilihanPengguna = 4) or 
			(pilihanPengguna = 5) or (pilihanPengguna = 6) or (pilihanPengguna = 7) or (pilihanPengguna = 8);
	end;


	procedure pembelian();

	var

	begin
		writeln('List pembelian: ');
		writeln('1. Voucher Hp');
		writeln('2. Listrik');
		writeln('3. Taksi online');
		repeat
			write('Pilihan opsi pembayaran: ');
			readln(pilihanPengguna);
			if (pilihanPengguna = 1) or (pilihanPengguna = 2) or (pilihanPengguna = 3) then begin
				//Bayar sesuai tagihan, pastikan saldo cukup
			end
			else begin
				writeln('Pastikan opsi tepat. Silahkan coba lagi');
			end;
		until (pilihanPengguna = 1) or (pilihanPengguna = 2) or (pilihanPengguna = 3);
	end;
