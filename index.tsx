import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

// Error Boundary to prevent white screen crashes
class ErrorBoundary extends React.Component<{children: React.ReactNode}, {hasError: boolean, error: any}> {
  constructor(props: any) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: any) {
    return { hasError: true, error };
  }

  componentDidCatch(error: any, errorInfo: any) {
    console.error("Uncaught error:", error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div style={{padding: 20, backgroundColor: '#0B0B0C', color: 'white', height: '100vh', display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', fontFamily: 'sans-serif'}}>
          <h1 style={{color: '#F0C419', fontSize: '2rem', marginBottom: '1rem'}}>มีข้อผิดพลาดเกิดขึ้น</h1>
          <p style={{color: '#9CA3AF', marginBottom: '2rem'}}>ระบบขัดข้อง กรุณาลองใหม่</p>
          <div style={{backgroundColor: '#151516', padding: '1rem', borderRadius: '8px', border: '1px solid #27272A', maxWidth: '600px', overflow: 'auto', marginBottom: '2rem'}}>
             <code style={{color: '#ef4444'}}>{this.state.error?.message}</code>
          </div>
          <button 
            onClick={() => {
              localStorage.clear();
              window.location.reload();
            }} 
            style={{padding: '12px 24px', backgroundColor: '#F0C419', border: 'none', borderRadius: '8px', fontWeight:'bold', cursor: 'pointer', color: '#0B0B0C'}}
          >
            รีเซ็ตระบบและลองใหม่
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}

const rootElement = document.getElementById('root');
if (!rootElement) {
  throw new Error("Could not find root element to mount to");
}

const root = ReactDOM.createRoot(rootElement);
root.render(
  <React.StrictMode>
    <ErrorBoundary>
      <App />
    </ErrorBoundary>
  </React.StrictMode>
);