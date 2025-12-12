
program CampusSchedule;
uses crt;

type
  // Record untuk menyimpan tanggal (dd, mm, yyyy)
  Tanggal = record
    dd : 1..31;
    mm : 1..12;
    yyyy : 2000..2100;
  end;

  // Record untuk menyimpan data jadwal kuliah
  JadwalKuliah = record
    hari: string;         
    jam_mulai: string;    
    jam_selesai: string;
    mata_kuliah: string;
    ruang: string;
  end;

  // Record untuk menyimpan data tugas
  Tugas = record
    nama: string;
    deskripsi: string;
    deadline: Tanggal;    // Nested record     
  end;

// VARIABEL GLOBAL
var
  daftarJadwal: array[1..20] of JadwalKuliah;  // Maks 20 jadwal
  daftarTugas: array[1..30] of Tugas;          // Maks 30 tugas
  jumlahJadwal, jumlahTugas: integer;          // Penghitung data
  pilihan: integer;                  
  Lanjut: Char;          // Input menu

// PROSEDUR: TAMPILKAN MENU UTAMA
procedure TampilkanMenu;
begin
  clrscr;
  writeln('====================================================');
  writeln('=                CAMPUS SCHEDULE                   =');
  writeln('=         Jadwal & Tugas Kuliah Mahasiswa          =');
  writeln('====================================================');
  writeln('1. Tambah Jadwal Kuliah');
  writeln('2. Tambah Tugas');
  writeln('3. Tampilkan Jadwal Hari Ini');
  writeln('4. Lihat Tugas Mendekati Deadline');
  writeln('5. Keluar');
  writeln('====================================================');
  write('>>> Pilih: ');
end;

// PROSEDUR: INPUT TANGGAL
procedure InputTanggal(var waktu : Tanggal);
begin
    with waktu do
    begin
      write('masukkan tanggal   :');readln(dd);
      write('masukkan bulan     :');readln(mm);
      write('masukkan tahun     :');readln(yyyy);
      writeln('hari ini adalah  : ', dd, '-', mm, '-', yyyy);
    end;
    readln;
end;

// PROSEDUR: TAMBAH JADWAL KULIAH
procedure TambahJadwal;
var
  j: JadwalKuliah;
  JdMK: integer;
begin
  if jumlahJadwal >= 20 then
  begin
    textcolor(yellow); writeln('Daftar jadwal penuh!'); textcolor(white);
    readln;
    exit;
  end;

  writeln('--- Tambah Jadwal Kuliah ---');
  JdMK := 0;
  repeat
  inc(JdMK);
  Writeln('Mata Kuliah Ke-', JdMK, ':');
  write('Hari           : '); readln(j.hari);
  write('Jam Mulai      : '); readln(j.jam_mulai);
  write('Jam Selesai    : '); readln(j.jam_selesai);
  write('Mata Kuliah    : '); readln(j.mata_kuliah);
  write('Ruang          : '); readln(j.ruang);
  // Simpan ke array
  jumlahJadwal := jumlahJadwal + 1;
  daftarJadwal[jumlahJadwal] := j;
  Writeln;
  write('Input jadwal lagi? (Y/T): '); readln(Lanjut);
  until (upcase(Lanjut) = 'T') or (JdMK > 20);
  Writeln('Total ', JdMK , ' jadwal tersimpan.');
  textcolor(green); writeln(' Jadwal berhasil ditambahkan!'); textcolor(white);
  readln; 
end;

// PROSEDUR: TAMBAH TUGAS
procedure TambahTugas;
var
  t: Tugas;
  TmbhTugas: integer;
begin
  if jumlahTugas >= 30 then
  begin
    textcolor(yellow); writeln('Daftar tugas penuh!'); textcolor(white);
    readln;
    exit;
  end;

  writeln('--- Tambah Tugas ---');
  TmbhTugas := 0;
  repeat
  inc(TmbhTugas);
  Writeln('Tugas Ke-', TmbhTugas, ':');
  write('Nama Tugas : '); readln(t.nama);
  write('Deskripsi  : '); readln(t.deskripsi);
  writeln('Deadline :');
  InputTanggal(t.deadline);
  // Simpan ke array
  jumlahTugas := jumlahTugas + 1;
  daftarTugas[jumlahTugas] := t;
  Writeln;
  write('Input tugas lagi? (Y/T): '); readln(Lanjut);
  until (upcase(Lanjut) = 'T') or (TmbhTugas > 30);
  textcolor(green); writeln(' Tugas berhasil ditambahkan!'); textcolor(white);
  readln;
end;

// PROSEDUR: TAMPILKAN JADWAL HARI INI
procedure TampilkanJadwalHariIni;
var
  i: integer;
  hariIni: string;
begin
  writeln('--- Tampilkan Jadwal Hari Ini ---');
  write('Masukkan hari (contoh: Senin): '); readln(hariIni);

  // Header tabel
  writeln('No | Mata Kuliah        | Jam         | Ruang');
  writeln('-----------------------------------------------');

  // Perulangan untuk cek semua jadwal
  for i := 1 to jumlahJadwal do
  begin
    if daftarJadwal[i].hari = hariIni then
    begin
      // Tampilkan data dengan format rapi
      writeln(i:2, ' | ', daftarJadwal[i].mata_kuliah:20, ' | ', daftarJadwal[i].jam_mulai, '-', daftarJadwal[i].jam_selesai, ' | ', daftarJadwal[i].ruang);
    end;
  end;
  readln;
end;

// FUNGSI: HITUNG SELISIH HARI (sederhana)
function HitungSelisihHari(tglSekarang, tglDeadline: Tanggal): integer;
begin
  // Asumsi: 1 tahun = 365 hari, 1 bulan = 30 hari
  HitungSelisihHari := (tglDeadline.yyyy - tglSekarang.yyyy) * 365 + (tglDeadline.mm - tglSekarang.mm) * 30 + (tglDeadline.dd - tglSekarang.dd);
end;

// PROSEDUR: LIHAT TUGAS DENGAN DEADLINE ≤ 3 HARI
procedure LihatTugasDeadline;
var
  i: integer;
  tglSekarang: Tanggal;
  selisih: integer;
begin
  writeln('--- Tugas Mendekati Deadline (≤ 3 hari) ---');
  writeln('Masukkan tanggal hari ini:');
  InputTanggal(tglSekarang);

  // Header tabel
  writeln(' No |             Nama Tugas            |       Deadline    ');
  writeln('------------------------------------------------------------');
  // Perulangan cek semua tugas
  for i := 1 to jumlahTugas do
  begin
    selisih := HitungSelisihHari(tglSekarang, daftarTugas[i].deadline);
    // Cek apakah deadline masih di masa depan dan ≤ 3 hari
    if (selisih >= 0) and (selisih <= 3) then
    begin
      writeln( i:2, '  | ', daftarTugas[i].nama:20, ' | ', daftarTugas[i].deadline.dd:2, '/', daftarTugas[i].deadline.mm:2, '/', daftarTugas[i].deadline.yyyy:4 );
    end;
  end;
  readln;
end;

// PROGRAM UTAMA
begin
  // Inisialisasi awal
  jumlahJadwal := 0;
  jumlahTugas := 0;

  // Loop menu utama
  repeat
    TampilkanMenu;
    readln(pilihan);

    // Operasi kondisi: pilih menu
    case pilihan of
      1: TambahJadwal;
      2: TambahTugas;
      3: TampilkanJadwalHariIni;
      4: LihatTugasDeadline;
      5: begin
        writeln('Keluar dari program...');
        textcolor(green); writeln(' Terima kasih telah menggunakan Campus Schedule!'); textcolor(white);
        readln;
      end;
      else
      begin
        textcolor(red); writeln(' Pilihan tidak valid! Tekan Enter untuk kembali.'); textcolor(white);
        readln;
      end;
    end;

  until pilihan = 5; // Keluar jika pilih 5
end. 