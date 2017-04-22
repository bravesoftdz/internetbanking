unit AccountHistory;
{Mengelola pengecekan informasi data rekening}
{ NOTE: kurang lihatAktivitasTransaksi}

interface
	
	uses
		DataTypes, dateandtime;

	procedure lihatRekening(rekeningTerdaftar : dataRekening; nomorNasabah : string; pilihanRekening : integer);
	procedure informasiSaldo(rekeningTerdaftar : dataRekening; nomorNasabah : string; nomorAkun : string; var isSuccess: boolean);
	//procedure lihatAktivitasTransaksi(); {belum ada}

implementation

	procedure lihatRekening(rekeningTerdaftar : dataRekening; nomorNasabah : string; pilihanRekening : integer);
	
	var
		i, j, jumlahRekening : integer;
		dataRekeningPemilik : array[1..100] of string;
		jenisRekening : string;
		pilihanBenar : boolean;

	begin
		j := 0;
		pilihanBenar := False;
		case (pilihanRekening) of
			1 : jenisRekening := 'deposito';
			2 : jenisRekening := 'tabungan rencana';
			3 : jenisRekening := 'tabungan mandiri'
			else
			begin
				writeln('Pilihan salah');
				pilihanBenar := True;
			end;
		end;
		if (pilihanBenar) then
		begin
			for i := 1 to rekeningTerdaftar.jumlahData do
			begin
				if (rekeningTerdaftar.data[i].nomorNasabah = nomorNasabah) then
				begin
					if (rekeningTerdaftar.data[i].jenisRekening = jenisRekening) then
					begin
						j := j + 1;
						dataRekeningPemilik[j] := rekeningTerdaftar.data[i].nomorAkun;
					end;
				end;
			end;
			jumlahRekening := j;
			if jumlahRekening = 0 then writeln('Anda tidak mempunyai ', jenisRekening)
			else
			begin
				writeln('Pilih rekening ', jenisRekening, ' Anda:');
				for i := 1 to jumlahRekening do
				begin
					writeln(i, '. ', dataRekeningPemilik[i]);
				end;
			end;
		end;
	end;


	procedure informasiSaldo(rekeningTerdaftar: dataRekening; nomorNasabah: string; nomorAkun: string; var isSuccess : boolean);
	
	var
		i: integer;

	begin
		isSuccess := False;
		for i := 1 to rekeningTerdaftar.jumlahData do
		begin
			if (rekeningTerdaftar.data[i].nomorAkun = nomorAkun) then
			begin
				write('Nomor rekening: ');
				writeln(rekeningTerdaftar.data[i].nomorAkun);
				write('Tanggal mulai: ');
				writeln(rekeningTerdaftar.data[i].tanggalMulai);
				write('Jangka waktu: ');
				writeln(rekeningTerdaftar.data[i].jangkaWaktu);
				write('Setoran rutin: ');
				writeln(rekeningTerdaftar.data[i].setoranRutin);
				write('Saldo: ');
				writeln(rekeningTerdaftar.data[i].saldo);
				isSuccess := True;
			end;
		end;
	end;

end.