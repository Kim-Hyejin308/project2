// 관리자 페이지 공통 레이아웃: 사이드바 네비게이션 + 콘텐츠 영역
import { NavLink, Outlet, useNavigate } from 'react-router-dom'  // React Router 컴포넌트
import {
  LayoutDashboard,  // 대시보드 아이콘
  Users,            // 회원 관리 아이콘
  Package,          // 물품 관리 아이콘
  ArrowLeftRight,   // 거래 관리 아이콘
  Truck,            // 배달대행 아이콘
  Flag,             // 신고 관리 아이콘
  Building2,        // 브랜드 문의 아이콘
  Bell,             // 공지/이벤트 아이콘
  ImageIcon,        // 배너 관리 아이콘
  LogOut,           // 로그아웃 아이콘
  ShieldCheck,      // 관리자 로고 아이콘
} from 'lucide-react'
import { useMutation } from '@tanstack/react-query'  // React Query 뮤테이션 훅
import { authApi } from '@/features/auth/api'         // 인증 API
import { useAuthStore } from '@/features/auth/store'  // 인증 상태 스토어
import { cn } from '@/shared/lib/cn'                  // Tailwind 클래스 유틸리티

// 사이드바 메뉴 항목 타입 정의
interface MenuItem {
  label: string                              // 메뉴 표시 이름
  path:  string                              // 링크 경로
  icon:  React.ComponentType<{ size?: number; className?: string }>  // 아이콘 컴포넌트
}

// 관리자 사이드바 메뉴 목록 (순서 = 중요도 순)
const ADMIN_MENU: MenuItem[] = [
  { label: '대시보드',    path: '/admin/dashboard', icon: LayoutDashboard },  // UC-41
  { label: '회원 관리',   path: '/admin/users',     icon: Users },            // UC-42
  { label: '물품 관리',   path: '/admin/items',     icon: Package },          // UC-44
  { label: '거래 관리',   path: '/admin/trades',    icon: ArrowLeftRight },   // UC-43
  { label: '배달대행',    path: '/admin/delivery',  icon: Truck },            // UC-47
  { label: '신고 관리',   path: '/admin/reports',   icon: Flag },             // UC-45
  { label: '브랜드 문의', path: '/admin/brands',    icon: Building2 },        // UC-46
  { label: '공지/이벤트', path: '/admin/notices',   icon: Bell },             // UC-48
  { label: '배너 관리',   path: '/admin/banners',   icon: ImageIcon },        // UC-49
]

// 관리자 레이아웃 메인 컴포넌트
export default function AdminLayout() {
  const navigate = useNavigate()
  // 현재 로그인된 관리자 정보
  const user    = useAuthStore((s) => s.user)
  // 로그아웃 상태 초기화 함수
  const logout  = useAuthStore((s) => s.logout)

  // 로그아웃 뮤테이션
  const { mutate: doLogout } = useMutation({
    mutationFn: () => authApi.logout(),
    onSettled: () => {
      logout()                       // 스토어 상태 초기화
      navigate('/admin/login')       // 관리자 로그인 페이지로 이동
    },
  })

  return (
    <div className="flex min-h-screen bg-gray-100">
      {/* ── 왼쪽 사이드바 ── */}
      <aside className="w-60 shrink-0 bg-gray-900 text-white flex flex-col">
        {/* 사이드바 상단: 관리자 로고 */}
        <div className="flex items-center gap-2.5 px-5 py-5 border-b border-gray-700">
          <ShieldCheck size={22} className="text-blue-400" />
          <span className="text-base font-bold tracking-tight">쓸랭 관리자</span>
        </div>

        {/* 현재 관리자 계정 정보 */}
        <div className="px-5 py-3 border-b border-gray-700">
          <p className="text-xs text-gray-400">로그인 계정</p>
          <p className="text-sm font-medium text-white truncate mt-0.5">
            {user?.nickname ?? '관리자'}
          </p>
        </div>

        {/* 네비게이션 메뉴 목록 */}
        <nav className="flex-1 overflow-y-auto py-3">
          <ul className="space-y-0.5 px-2">
            {ADMIN_MENU.map(({ label, path, icon: Icon }) => (
              <li key={path}>
                <NavLink
                  to={path}
                  className={({ isActive }) =>
                    cn(
                      'flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors',
                      isActive
                        ? 'bg-blue-600 text-white'           // 활성 메뉴 스타일
                        : 'text-gray-300 hover:bg-gray-700 hover:text-white'  // 비활성 메뉴 스타일
                    )
                  }
                >
                  <Icon size={17} />
                  <span>{label}</span>
                </NavLink>
              </li>
            ))}
          </ul>
        </nav>

        {/* 사이드바 하단: 로그아웃 버튼 */}
        <div className="px-2 py-3 border-t border-gray-700">
          <button
            onClick={() => doLogout()}
            className="flex items-center gap-3 w-full px-3 py-2.5 rounded-lg text-sm font-medium text-gray-300 hover:bg-gray-700 hover:text-white transition-colors"
          >
            <LogOut size={17} />
            <span>로그아웃</span>
          </button>
        </div>
      </aside>

      {/* ── 오른쪽 콘텐츠 영역 ── */}
      <main className="flex-1 overflow-y-auto">
        {/* 콘텐츠 최대 너비 제한 및 패딩 */}
        <div className="max-w-6xl mx-auto p-8">
          <Outlet />
        </div>
      </main>
    </div>
  )
}
