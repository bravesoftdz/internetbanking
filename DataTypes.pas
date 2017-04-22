unit DataTypes;
{Penyimpan konstanta, variabel, tipe bentukan yang dibutuhkan}

interface

	const usdToIDR : longint = 13301;
	const eurToIDR : longint = 14164;

type 

	rekening = record
		nomorAkun : string;
		nomorNasabah : string;
		jenisRekening : string;
		mataUang : string;
		saldo : longint;
		setoranRutin : longint;
		rekeningAutoDebet : string;
		jangkaWaktu : integer;
		tanggalMulai : string;
	end;

	nasabah = record 
		nomor : string;
		nama : string;
		alamat : string;
		kota : string;
		email : string;
		nomorTelefon : string;
		username : string;
		password : string;
		status : string;
	end;

	transaksiSetoran = record
		nomorAkun : string;
		jenisTransaksi : string;
		mataUang : string;
		jumlah : longint;
		saldo : longint;
		tanggalTransaksi : string;
	end;

	transaksiTransfer = record
		nomorAkunAsal : string;
		nomorAkunTujuan : string;
		jenisTransfer : string;
		namaBank : string;
		mataUang : string;
		jumlah : longint;
		saldo : longint;
		tanggalTransaksi : string;
	end;

	dataTransaksiTransfer = record
		data : array[1..100] of transaksiTransfer;
		indexTerakhir : integer;
	end;

	dataNasabah = record
		data : array[1..100] of nasabah;
		jumlahData : integer;
		indexTerakhir : integer;
	end;

	dataRekening = record
		data : array[1..100] of rekening;
		jumlahData : integer;
		indexTerakhir : integer;
	end;

	dataTransaksi = record
		data : array[1..100] of transaksiSetoran;
		jumlahData : integer;
		indexTerakhir : integer;
	end;

{ KAMUS GLOBAL }

	var
		counter: integer;
		nomor: string;

implementation
begin

end.