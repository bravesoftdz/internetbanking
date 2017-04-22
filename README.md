# internet banking
# Tugas Besar Daspro

total 17 fungsi&prosedur

Dibagi jadi 6 unit:

- unit DataTypes; {Penyimpan konstanta, variabel, tipe bentukan yang dibutuhkan}
  
- unit FileExtLoader; {Mengelola file eksternal yang dipakai dalam program}
  - procedure load(fileLocation : string);
  - procedure exit();

- unit SettingRekening; {Unit yang mengelola pembuatan, perubahan data, dan penutupan rekening+LOGIN}
  { 	NOTE: 	kurang penutupanrekening }
  - procedure login();
  - procedure pembuatanRekening();
  - procedure perubahanDataNasabah();
  - //procedure penutupanRekening();
 
- unit AccountHistory; {Mengelola pengecekan informasi data rekening}
  { NOTE: kurang lihatAktivitasTransaksi}
  - procedure lihatRekening();
  - procedure informasiSaldo();
  - //procedure lihatAktivitasTransaksi(); {belum ada}

- unit Transaction; {Mengelola fitur transaksi pada akun rekening}
    {NOTE: kurang penambahanAutoDebet. Masih banyak compile error } 
  - function validTabunganRencana();
  - function validDeposito();
  - procedure setoran();
  - procedure penarikan();
  - procedure transfer();
  - procedure pembayaran();
  - procedure pembelian();
  - //procedure penambahanAutoDebet(); {belum ada}

- unit dateAndTime; {Penanggalan}
