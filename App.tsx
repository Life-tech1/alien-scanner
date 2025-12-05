import React, { useState, useEffect } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { UserRole } from './types';
import { Layout } from './components/Layout';
import { RiderDashboard } from './pages/RiderDashboard';
import { RestaurantDashboard } from './pages/RestaurantDashboard';
import { Earnings } from './pages/Earnings';
import { WalletPage } from './pages/WalletPage';
import { AdminDashboard } from './pages/AdminDashboard';
import { HomePage } from './pages/HomePage';
import { CustomerDashboard } from './pages/CustomerDashboard';
import { RestaurantDetailPage } from './pages/RestaurantDetailPage';
import { CheckoutPage } from './pages/CheckoutPage';
import { RestaurantMenuPage } from './pages/RestaurantMenuPage';
import { RiderJobPage } from './pages/RiderJobPage';
import { CustomerRidePage } from './pages/CustomerRidePage';
import { ChatPage } from './pages/ChatPage';
import { DeliveryPage } from './pages/DeliveryPage';
import { Bike, Store, Wallet, LogOut, CreditCard, Shield, Home, Activity } from 'lucide-react';
import { Button, Input, Card } from './components/UI';
import { supabase, isSupabaseConfigured } from './lib/supabaseClient';
import { ApiService } from './services/api';
import { NotificationProvider, useNotification } from './context/NotificationContext';
import { CartProvider } from './context/CartContext';

const PageTransition = ({ children, pageKey }: { children: React.ReactNode, pageKey: string }) => (
  <motion.div
    key={pageKey}
    initial={{ opacity: 0, y: 10 }}
    animate={{ opacity: 1, y: 0 }}
    exit={{ opacity: 0, y: -10 }}
    transition={{ duration: 0.2 }}
    className="w-full h-full"
  >
    {children}
  </motion.div>
);

const App: React.FC = () => {
  const [session, setSession] = useState<any>(null);
  const [userRole, setUserRole] = useState<UserRole>('guest');
  const [currentPage, setCurrentPage] = useState<string>('home');
  const [appState, setAppState] = useState<'loading' | 'setup' | 'login' | 'role_select' | 'ready'>('loading');
  const [pageParams, setPageParams] = useState<any>(null);



  // Login Inputs
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoginView, setIsLoginView] = useState(true);
  const [authError, setAuthError] = useState('');
  const [authLoading, setAuthLoading] = useState(false);

  useEffect(() => {
    checkSystemStatus();
  }, []);

  const checkSystemStatus = async () => {
    // 1. Check Config
    if (!isSupabaseConfigured()) {
      setAppState('setup');
      return;
    }

    // 2. Check Session
    try {
      const { data } = await supabase.auth.getSession();
      if (data.session) {
        setSession(data.session);
        await fetchUserProfile(data.session.user.id);
      } else {
        setAppState('login');
      }

      // Listen for changes
      supabase.auth.onAuthStateChange((_event: string, session: any) => {
        setSession(session);
        if (session) {
          fetchUserProfile(session.user.id);
        } else {
          setAppState('login');
          setUserRole('guest');
        }
      });
    } catch (e) {
      console.error("Session check failed", e);
      setAppState('login');
    }
  };

  const fetchUserProfile = async (userId: string) => {
    try {
      const user = await ApiService.getUserProfile(userId);
      if (user && (user.role === 'rider' || user.role === 'restaurant' || user.role === 'admin' || user.role === 'customer')) {
        setUserRole(user.role as UserRole);

        // Routing Logic:
        // Customer -> Home (Services)
        // Rider/Restaurant -> Dashboard (Work/Manage)
        if (user.role === 'customer') {
          setCurrentPage('home');
        } else {
          setCurrentPage('dashboard');
        }

        setAppState('ready');
      } else {
        setUserRole('guest');
        setAppState('role_select');
      }
    } catch (e) {
      console.error("Profile Error", e);
      setUserRole('guest');
      setAppState('role_select');
    }
  };

  const handleLogin = async () => {
    setAuthLoading(true);
    setAuthError('');



    // Auto-Email Domain
    const username = email.trim();
    let finalEmail = username;
    if (!finalEmail.includes('@')) finalEmail = `${finalEmail}@runing.app`;

    try {
      if (!isSupabaseConfigured()) {
        throw new Error("ระบบยังไม่ได้เชื่อมต่อ Database");
      }

      const { error } = isLoginView
        ? await supabase.auth.signInWithPassword({ email: finalEmail, password })
        : await supabase.auth.signUp({ email: finalEmail, password });

      if (error) throw error;
    } catch (err: any) {
      setAuthError(err.message || 'เข้าสู่ระบบไม่สำเร็จ');

    } finally {
      setAuthLoading(false);
    }
  };

  const handleLogout = async () => {
    await supabase.auth.signOut();
    window.location.reload();
  };

  // --- RENDERING STATES ---

  if (appState === 'loading') {
    return <div className="min-h-screen bg-[#0B0B0C] flex items-center justify-center text-[#F0C419] font-bold animate-pulse">RUNING SYSTEM...</div>;
  }



  if (appState === 'login') {
    return (
      <div className="min-h-screen bg-[#0B0B0C] flex items-center justify-center p-4">
        <Card className="w-full max-w-md border-[#F0C419]/30">
          <h1 className="text-3xl font-extrabold text-center italic text-white mb-8">
            RUN<span className="text-[#F0C419]">ING.</span>
          </h1>
          <h2 className="text-lg font-bold text-white mb-4 text-center">{isLoginView ? 'เข้าสู่ระบบ' : 'สมัครสมาชิก'}</h2>

          {authError && <div className="bg-red-900/20 text-red-500 p-3 rounded text-sm mb-4 text-center">{authError}</div>}

          <Input label="ชื่อผู้ใช้ หรือ อีเมล" value={email} onChange={e => setEmail(e.target.value)} placeholder="เช่น topjang123" />
          <Input label="รหัสผ่าน" type="password" value={password} onChange={e => setPassword(e.target.value)} />

          <Button fullWidth onClick={handleLogin} disabled={authLoading}>
            {authLoading ? 'กำลังตรวจสอบ...' : (isLoginView ? 'เข้าสู่ระบบ' : 'ลงทะเบียน')}
          </Button>

          <button onClick={() => setIsLoginView(!isLoginView)} className="w-full text-center mt-4 text-[#F0C419] text-sm hover:underline">
            {isLoginView ? 'ยังไม่มีบัญชี? สมัครสมาชิก' : 'มีบัญชีแล้ว? เข้าสู่ระบบ'}
          </button>


        </Card>
      </div>
    );
  }

  if (appState === 'role_select') {
    return (
      <div className="min-h-screen bg-[#0B0B0C] flex items-center justify-center p-4">
        <Card className="w-full max-w-md text-center">
          <h2 className="text-2xl font-bold text-white mb-6">เลือกสถานะของคุณ</h2>
          <div className="space-y-4">
            <Button fullWidth onClick={async () => {
              await ApiService.updateUserProfile({ id: session.user.id, role: 'customer', name: email.split('@')[0] });
              setUserRole('customer');
              setCurrentPage('home');
              setAppState('ready');
            }}>ฉันคือลูกค้า (Customer)</Button>

            <Button fullWidth variant="outline" onClick={async () => {
              await ApiService.updateUserProfile({ id: session.user.id, role: 'rider', name: email.split('@')[0] });
              setUserRole('rider');
              setCurrentPage('dashboard');
              setAppState('ready');
            }}>ฉันคือไรเดอร์ (Rider)</Button>

            <Button fullWidth variant="secondary" onClick={async () => {
              await ApiService.updateUserProfile({ id: session.user.id, role: 'restaurant', name: email.split('@')[0] });
              setUserRole('restaurant');
              setCurrentPage('dashboard');
              setAppState('ready');
            }}>ฉันคือร้านอาหาร (Restaurant)</Button>

            {/* Option to become an Admin - for testing/setup purposes */}
            <Button fullWidth variant="outline" onClick={async () => {
              await ApiService.updateUserProfile({ id: session.user.id, role: 'admin', name: email.split('@')[0] });
              setUserRole('admin');
              setAppState('ready');
            }}>ฉันคือผู้ดูแลระบบ (Admin)</Button>
          </div>
        </Card>
      </div>
    );
  }

  const handleNavigate = (page: string, params?: any) => {
    setCurrentPage(page);
    if (params) setPageParams(params);
  };

  const renderPage = () => {
    switch (currentPage) {
      case 'home': return <HomePage onNavigate={handleNavigate} userName={session.user.email?.split('@')[0]} />;
      case 'restaurant_detail':
        return <RestaurantDetailPage
          restaurantId={pageParams?.id}
          restaurantName={pageParams?.name}
          restaurantLat={pageParams?.lat}
          restaurantLng={pageParams?.lng}
          restaurantAddress={pageParams?.address}
          onBack={() => setCurrentPage('home')}
          onViewCart={() => setCurrentPage('checkout')}
        />;
      case 'checkout':
        return <CheckoutPage
          session={session}
          onBack={() => setCurrentPage('restaurant_detail')}
          onSuccess={() => {
            alert('สั่งซื้อสำเร็จ! รอรับอาหารได้เลย');
            setCurrentPage('tracking');
          }}
        />;
      case 'rider_job':
        if (!pageParams?.jobId) return <HomePage onNavigate={handleNavigate} userName={session.user.email?.split('@')[0]} />;
        return (
          <RiderJobPage
            jobId={pageParams.jobId}
            session={session}
            onBack={() => handleNavigate(session?.user?.user_metadata?.role === 'rider' ? 'rider_dashboard' : 'home')}
            onNavigate={handleNavigate}
          />
        );
      case 'customer_ride':
        return <CustomerRidePage session={session} onBack={() => handleNavigate('home')} onNavigate={handleNavigate} />;
      case 'delivery':
        return <DeliveryPage session={session} onBack={() => handleNavigate('home')} />;
      case 'chat': return <RestaurantDashboard session={session} />;
      case 'dashboard':
        if (userRole === 'customer') return <CustomerDashboard session={session} />;
        return userRole === 'rider' ? <RiderDashboard session={session} onNavigate={handleNavigate} /> : <RestaurantDashboard session={session} />;
      case 'menu':
        return <RestaurantMenuPage session={session} onBack={() => setCurrentPage('dashboard')} />;
      case 'create': return <RestaurantDashboard session={session} />;
      case 'tracking':
        if (userRole === 'customer') return <CustomerDashboard session={session} />;
        return userRole === 'rider' ? <RiderDashboard session={session} defaultView="active" onNavigate={handleNavigate} /> : <RestaurantDashboard session={session} />;
      case 'earnings': return <Earnings />;
      case 'wallet': return <WalletPage />;
      case 'admin': return <AdminDashboard />;

      // New Game-Like Pages
      case 'rider_job':
        return <RiderJobPage session={session} jobId={pageParams?.jobId} onBack={() => setCurrentPage('dashboard')} onNavigate={handleNavigate} />;
      case 'ride':
        return <CustomerRidePage session={session} onBack={() => setCurrentPage('home')} onNavigate={handleNavigate} />;
      case 'chat':
        return <ChatPage session={session} jobId={pageParams?.jobId} onBack={() => setCurrentPage('dashboard')} />;

      case 'profile': return (
        <div className="p-8 text-center">
          <h2 className="text-2xl text-white font-bold mb-4">{session.user.email}</h2>
          <span className="bg-[#F0C419] text-black px-3 py-1 rounded-full font-bold uppercase">{userRole}</span>
          <Button className="mt-8 bg-red-600 text-white border-none" onClick={handleLogout}>ออกจากระบบ</Button>
        </div>
      );
      default: return <div className="text-white">Page Not Found</div>;
    }
  };



  return (
    <NotificationProvider>
      <CartProvider>
        <Layout userRole={userRole} currentPage={currentPage} onNavigate={handleNavigate} onLogout={handleLogout}>
          <AnimatePresence mode="wait">
            <PageTransition pageKey={currentPage}>
              {renderPage()}
            </PageTransition>
          </AnimatePresence>
        </Layout>
      </CartProvider>
    </NotificationProvider>
  );
};

export default App;