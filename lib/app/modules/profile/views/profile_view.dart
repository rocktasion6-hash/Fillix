import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../utils/constants.dart'; // Import constant

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  final ProfileController controller = Get.put(ProfileController());

  // Warna khusus icon/teks di atas tombol kuning
  static const Color darkBrown = Color(0xFF443127);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Background utama
      appBar: AppBar(
        title: const Text(
          'Halaman Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
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
                    color: AppColors.surface, // Warna Card Cokelat Terang
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
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
                          color: AppColors.accent.withOpacity(0.15),
                          border: Border.all(color: AppColors.accent, width: 2),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: 55,
                          color:
                              AppColors.accent, // Icon disesuaikan agar terang
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
                          color: AppColors.textWhite,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Email User
                      Text(
                        controller.email.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Badge Role
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isAdmin
                              ? Colors.red.withOpacity(0.2)
                              : Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: isAdmin
                                ? Colors.red[300]!
                                : Colors.blue[300]!,
                          ),
                        ),
                        child: Text(
                          controller.role.value.toUpperCase(),
                          style: TextStyle(
                            color: isAdmin ? Colors.red[200] : Colors.blue[200],
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
                      backgroundColor: AppColors.accent,
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
            color: AppColors.textGrey, // Menggunakan teks abu-abu agar harmonis
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
        color: AppColors.surface, // Background Card
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
            color: AppColors.accent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.accent),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textWhite, // Teks putih
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppColors.textGrey, // Teks subtitle abu-abu
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: AppColors.textGrey,
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Akun Saya',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textWhite,
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
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withOpacity(0.15),
                  border: Border.all(color: AppColors.accent, width: 3),
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 65,
                  color: AppColors.accent,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              controller.name.value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textWhite,
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                      color: AppColors.textWhite,
                    ),
                  ),
                  Divider(
                    height: 24,
                    thickness: 1,
                    color: AppColors.textGrey.withOpacity(0.2),
                  ),
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
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                      color: AppColors.textWhite,
                    ),
                  ),
                  Divider(
                    height: 24,
                    thickness: 1,
                    color: AppColors.textGrey.withOpacity(0.2),
                  ),
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
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.accent, size: 20),
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
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textWhite,
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
  Key _futureKey = UniqueKey();

  Future<List<dynamic>> fetchDaftarUser() async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('profiles')
        .select()
        .neq('role', 'admin');
    return response as List<dynamic>;
  }

  Future<void> hapusUser(String id, String name) async {
    try {
      final supabase = Supabase.instance.client;
      await supabase.from('profiles').delete().eq('id', id);

      setState(() {
        _futureKey = UniqueKey();
      });

      Get.snackbar(
        'Sukses',
        'Pengguna "$name" berhasil dihapus.',
        backgroundColor: AppColors.accent,
        colorText: Color(0xFF443127),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Daftar Pengguna',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textWhite,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        key: _futureKey,
        future: fetchDaftarUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }
          if (snapshot.hasError ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Tidak ada data pengguna terdaftar.',
                style: TextStyle(color: AppColors.textGrey, fontSize: 15),
              ),
            );
          }

          final listUser = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: listUser.length,
            itemBuilder: (context, index) {
              final userData = listUser[index];
              final String userId = userData['id'] ?? '';
              final String userEmail = userData['email'] ?? 'Tidak ada email';
              final String userName =
                  userData['name'] ?? userEmail.split('@').first;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
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
                    backgroundColor: AppColors.accent.withOpacity(0.15),
                    child: const Icon(Icons.person, color: AppColors.accent),
                  ),
                  title: Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                  subtitle: Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue[300]!),
                        ),
                        child: Text(
                          (userData['role'] ?? 'USER').toString().toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[200],
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red[400],
                          size: 22,
                        ),
                        onPressed: () {
                          Get.defaultDialog(
                            title: 'Hapus Pengguna',
                            backgroundColor: AppColors.surface,
                            titleStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textWhite,
                            ),
                            middleText:
                                'Apakah kamu yakin ingin menghapus akun "$userName"?',
                            middleTextStyle: const TextStyle(
                              color: AppColors.textGrey,
                            ),
                            textConfirm: 'Hapus',
                            confirmTextColor: Colors.white,
                            buttonColor: Colors.red[600],
                            textCancel: 'Batal',
                            cancelTextColor: AppColors.accent,
                            onConfirm: () {
                              Get.back();
                              hapusUser(userId, userName);
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Tiket Saya',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textWhite,
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
            child: CircularProgressIndicator(color: AppColors.accent),
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
                  color: AppColors.textGrey.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada tiket yang dipesan',
                  style: TextStyle(
                    color: AppColors.textGrey,
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
                color: AppColors.surface, // Background card tiket
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                              color: AppColors.accent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.movie_creation_rounded,
                              color: AppColors.accent,
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
                                    color:
                                        AppColors.textWhite, // Judul film putih
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 13,
                                      color: AppColors.textGrey,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      t['tanggal_tayang'] ?? '-',
                                      style: TextStyle(
                                        color: AppColors.textGrey,
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
                    // Garis Putus-putus ala tiket, disesuaikan dengan warna bg utama
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: List.generate(
                          30,
                          (i) => Expanded(
                            child: Container(
                              color: i % 2 == 0
                                  ? Colors.transparent
                                  : AppColors.background,
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
                      color: Colors.black.withOpacity(
                        0.1,
                      ), // Bagian bawah sedikit lebih gelap
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
                                  color: AppColors.textGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                kursiText,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      AppColors.accent, // Kursi berwarna kuning
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
                              color: Colors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              '${t['jumlah_kursi'] ?? 0} Tiket',
                              style: TextStyle(
                                color: Colors.green[400], // Warna hijau terang
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
