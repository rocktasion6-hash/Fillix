import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  final ProfileController controller = Get.put(ProfileController());

  // Penyesuaian Palette Warna agar sinkron dengan Dashboard
  static final Color bgColor = Colors.grey[100]!;
  static const Color textDark = Colors.black87;
  static const Color textMuted = Colors.black54;
  static const Color accentYellow = Color(
    0xFFFBE488,
  ); // Warna tombol utama dashboard
  static const Color darkBrown = Color(
    0xFF443127,
  ); // Warna icon play di dashboard

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'Halaman Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: textDark),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: darkBrown),
            );
          }

          // Cek apakah user yang login memiliki role admin
          final isAdmin = controller.role.value.toLowerCase() == 'admin';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                // --- BAGIAN HEADER PROFILE ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Avatar Bingkai Kuning Lembut
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accentYellow.withOpacity(0.3),
                          border: Border.all(color: accentYellow, width: 2),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 55,
                          color: darkBrown,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Nama User
                      Text(
                        controller.name.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Email User
                      Text(
                        controller.email.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: textMuted),
                      ),
                      const SizedBox(height: 14),
                      // Badge Role
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isAdmin ? Colors.red[50] : Colors.blue[50],
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: isAdmin
                                ? Colors.red.withOpacity(0.3)
                                : Colors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          controller.role.value.toUpperCase(),
                          style: TextStyle(
                            color: isAdmin ? Colors.red[700] : Colors.blue[700],
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // --- KONTEN MENU BERDASARKAN ROLE ---
                if (isAdmin) ...[
                  // Menampilkan Menu Khusus Admin (Hanya Kelola Pengguna)
                  _buildSectionTitle('Menu Admin'),
                  _MenuCard(
                    icon: Icons.people_alt_rounded,
                    title: 'Kelola Pengguna',
                    subtitle: 'Manajemen hak akses & data user',
                    onTap: () {
                      Get.to(() => const KelolaPenggunaPage());
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                // Menu Umum yang bisa diakses oleh User maupun Admin
                _buildSectionTitle('Pengaturan Akun'),
                _MenuCard(
                  icon: Icons.account_circle_rounded,
                  title: 'Akun Saya',
                  subtitle: 'Informasi detail akun pengguna',
                  onTap: () {
                    Get.to(() => const AkunSayaPage());
                  },
                ),

                // Menu khusus user biasa (Menampilkan Tiket yang Dipesan)
                if (!isAdmin)
                  _MenuCard(
                    icon: Icons.confirmation_number_rounded,
                    title: 'Tiket Saya',
                    subtitle: 'Lihat riwayat transaksi tiket film',
                    onTap: () {
                      final user = controller.supabase.auth.currentUser;
                      if (user != null) {
                        controller.fetchRiwayatTiket(user.id);
                      }
                      Get.to(() => const RiwayatTiketPage());
                    },
                  ),

                _MenuCard(
                  icon: Icons.lock_rounded,
                  title: 'Keamanan',
                  subtitle: 'Ubah password dan proteksi akun',
                  onTap: () {},
                ),
                _MenuCard(
                  icon: Icons.info_rounded,
                  title: 'Tentang Aplikasi',
                  subtitle: 'Fillix App versi 1.0',
                  onTap: () {},
                ),
                const SizedBox(height: 20),

                // --- TOMBOL LOGOUT ---
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: controller.logout,
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentYellow,
                      foregroundColor: darkBrown,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Helper untuk membuat judul section menu
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 12),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: textMuted,
          ),
        ),
      ),
    );
  }
}

// ==========================================
// KELAS WIDGET PRIVATE _MenuCard
// ==========================================
class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFFBE488).withOpacity(0.2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF443127)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.black87.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: Colors.black38,
        ),
      ),
    );
  }
}

// ==========================================
// HALAMAN TAMPILAN DETAIL AKUN SAYA
// ==========================================
class AkunSayaPage extends StatelessWidget {
  const AkunSayaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    final userAuth = controller.supabase.auth.currentUser;
    String tglBergabung = '-';

    if (userAuth != null && userAuth.createdAt != null) {
      final dt = DateTime.parse(userAuth.createdAt!);
      final List<String> namaBulan = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      tglBergabung = '${dt.day} ${namaBulan[dt.month - 1]} ${dt.year}';
    }

    final Color bgColor = Colors.grey[100]!;
    const Color textDark = Colors.black87;
    const Color accentYellow = Color(0xFFFBE488);
    const Color darkBrown = Color(0xFF443127);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'Akun Saya',
          style: TextStyle(fontWeight: FontWeight.bold, color: textDark),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textDark,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentYellow.withOpacity(0.3),
                      border: Border.all(color: accentYellow, width: 3),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 65,
                      color: darkBrown,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              controller.name.value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Akun',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const Divider(height: 24, thickness: 1),
                  _buildInfoRow(
                    label: 'Alamat Email',
                    value: controller.email.value,
                    icon: Icons.mail_outline_rounded,
                  ),
                  _buildInfoRow(
                    label: 'Nomor Telepon / WhatsApp',
                    value: '+62 812-xxxx-xxxx',
                    icon: Icons.phone_android_rounded,
                  ),
                  _buildInfoRow(
                    label: 'Tanggal Bergabung',
                    value: 'Member sejak: $tglBergabung',
                    icon: Icons.calendar_today_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Tambahan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const Divider(height: 24, thickness: 1),
                  _buildInfoRow(
                    label: 'Jenis Kelamin',
                    value: 'Laki-laki / Perempuan',
                    icon: Icons.wc_rounded,
                  ),
                  _buildInfoRow(
                    label: 'Tanggal Lahir',
                    value: 'Belum diatur',
                    icon: Icons.cake_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFBE488).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF443127), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54.withOpacity(0.45),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// HALAMAN KELOLA PENGGUNA (DAFTAR NON-ADMIN)

class KelolaPenggunaPage extends StatefulWidget {
  const KelolaPenggunaPage({super.key});

  @override
  State<KelolaPenggunaPage> createState() => _KelolaPenggunaPageState();
}

class _KelolaPenggunaPageState extends State<KelolaPenggunaPage> {
  // Key unik untuk memicu reload pada FutureBuilder saat data berubah/dihapus
  Key _futureKey = UniqueKey();

  // Future untuk memuat user terdaftar dari tabel profiles selain admin
  Future<List<dynamic>> fetchDaftarUser() async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('profiles')
        .select()
        .neq('role', 'admin'); // Mem-filter agar admin tidak ikut muncul
    return response as List<dynamic>;
  }

  // Fungsi untuk mengeksekusi penghapusan user di database Supabase
  Future<void> hapusUser(String id, String name) async {
    try {
      final supabase = Supabase.instance.client;

      // Menghapus baris berdasarkan ID pengguna
      await supabase.from('profiles').delete().eq('id', id);

      // Memperbarui State dan mengganti Key agar FutureBuilder memanggil ulang data terbaru
      setState(() {
        _futureKey = UniqueKey();
      });

      Get.snackbar(
        'Sukses',
        'Pengguna "$name" berhasil dihapus.',
        backgroundColor: const Color(0xFFFBE488),
        colorText: const Color(0xFF443127),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus pengguna: $e',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Colors.grey[100]!;
    const Color textDark = Colors.black87;
    const Color darkBrown = Color(0xFF443127);
    const Color accentYellow = Color(0xFFFBE488);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'Daftar Pengguna',
          style: TextStyle(fontWeight: FontWeight.bold, color: textDark),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textDark,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        key:
            _futureKey, // Pasang key di sini agar widget tahu kapan harus refresh data
        future: fetchDaftarUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: darkBrown),
            );
          }
          if (snapshot.hasError ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Tidak ada data pengguna terdaftar.',
                style: TextStyle(color: Colors.grey[600], fontSize: 15),
              ),
            );
          }

          final listUser = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: listUser.length,
            itemBuilder: (context, index) {
              final userData = listUser[index];
              final String userId =
                  userData['id'] ?? ''; // Ambil ID untuk parameter hapus
              final String userEmail = userData['email'] ?? 'Tidak ada email';
              final String userName =
                  userData['name'] ?? userEmail.split('@').first;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.only(
                    left: 16,
                    right: 8,
                    top: 6,
                    bottom: 6,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: accentYellow.withOpacity(0.3),
                    child: const Icon(Icons.person, color: darkBrown),
                  ),
                  title: Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  subtitle: Text(
                    userEmail,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badge Role USER
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          (userData['role'] ?? 'USER').toString().toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Tombol Hapus Akun
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red[400],
                          size: 22,
                        ),
                        onPressed: () {
                          // Menampilkan Pop-up konfirmasi menggunakan dialog bawaan GetX
                          Get.defaultDialog(
                            title: 'Hapus Pengguna',
                            titleStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                            middleText:
                                'Apakah kamu yakin ingin menghapus akun "$userName"?',
                            middleTextStyle: const TextStyle(
                              color: Colors.black87,
                            ),
                            textConfirm: 'Hapus',
                            confirmTextColor: Colors.white,
                            buttonColor: Colors.red[600],
                            textCancel: 'Batal',
                            cancelTextColor: darkBrown,
                            onConfirm: () {
                              Get.back(); // Tutup dialog konfirmasi
                              hapusUser(
                                userId,
                                userName,
                              ); // Jalankan fungsi hapus data
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ==========================================
// HALAMAN TAMPILAN RIWAYAT TIKET SAYA
// ==========================================
class RiwayatTiketPage extends StatelessWidget {
  const RiwayatTiketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    final Color bgColor = Colors.grey[100]!;
    const Color textDark = Colors.black87;
    const Color accentYellow = Color(0xFFFBE488);
    const Color darkBrown = Color(0xFF443127);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          'Tiket Saya',
          style: TextStyle(fontWeight: FontWeight.bold, color: textDark),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textDark,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoadingTiket.value) {
          return const Center(
            child: CircularProgressIndicator(color: darkBrown),
          );
        }

        if (controller.tiketList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  size: 70,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada tiket yang dipesan',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: controller.tiketList.length,
          itemBuilder: (context, index) {
            final t = controller.tiketList[index];

            String kursiText = '-';
            if (t['kursi_dipilih'] != null) {
              if (t['kursi_dipilih'] is List) {
                kursiText = (t['kursi_dipilih'] as List).join(', ');
              } else {
                kursiText = t['kursi_dipilih'].toString();
              }
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: accentYellow.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.movie_creation_rounded,
                              color: darkBrown,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t['judul_film'] ?? 'Judul Film',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_rounded,
                                      size: 13,
                                      color: Colors.black45,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      t['tanggal_tayang'] ?? '-',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: List.generate(
                          30,
                          (i) => Expanded(
                            child: Container(
                              color: i % 2 == 0
                                  ? Colors.transparent
                                  : Colors.grey[200],
                              height: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      color: Colors.grey[50]!.withOpacity(0.6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'KURSI',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                kursiText,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: darkBrown,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              '${t['jumlah_kursi'] ?? 0} Tiket',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
