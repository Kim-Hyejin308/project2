// 관리자 로그인 페이지 컴포넌트 (UC-40: 관리자 로그인)
// 관리자 전용 이메일/비밀번호 로그인 폼

import { useState } from 'react'           // React 상태 훅
import { useNavigate } from 'react-router-dom'  // React Router 네비게이션 훅
import { ShieldCheck, Eye, EyeOff } from 'lucide-react'  // Lucide 아이콘
import { useMutation } from '@tanstack/react-query'  // React Query 뮤테이션 훅
import { authApi } from '@/features/auth/api'        // 인증 API
import { useAuthStore } from '@/features/auth/store' // 인증 상태 스토어

// 관리자 로그인 페이지 컴포넌트
export default function AdminLoginPage() {
  const navigate  = useNavigate()
  // 사용자 정보 저장 함수
  const setUser   = useAuthStore((s) => s.setUser)

  // 폼 입력 상태
  const [email,    setEmail]    = useState('')   // 관리자 이메일
  const [password, setPassword] = useState('')   // 비밀번호
  const [showPw,   setShowPw]   = useState(false) // 비밀번호 표시 여부
  const [error,    setError]    = useState('')   // 에러 메시지

  // 관리자 로그인 뮤테이션
  const { mutate: login, isPending } = useMutation({
    mutationFn: () => authApi.login({ email, password }).then((r) => r.data),
    onSuccess: (data) => {
      // 로그인 성공 후 관리자 권한 확인
      if (data.user.role !== 'ADMIN') {
        setError('관리자 계정이 아닙니다.')
        return
      }
      setUser(data.user)              // 관리자 정보 저장
      navigate('/admin/dashboard')    // 관리자 대시보드로 이동
    },
    onError: () => {
      setError('이메일 또는 비밀번호가 올바르지 않습니다.')
    },
  })

  /**
   * 폼 제출 핸들러
   * 이메일·비밀번호 유효성 확인 후 로그인 API 호출
   */
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    if (!email || !password) {
      setError('이메일과 비밀번호를 입력해 주세요.')
      return
    }
    login()
  }

  return (
    // 전체 화면 중앙 정렬 컨테이너
    <div className="min-h-screen bg-gray-950 flex items-center justify-center px-4">
      <div className="w-full max-w-sm">
        {/* 로고 및 제목 */}
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-14 h-14 bg-blue-600 rounded-2xl mb-4">
            <ShieldCheck size={28} className="text-white" />
          </div>
          <h1 className="text-2xl font-bold text-white">관리자 로그인</h1>
          <p className="text-sm text-gray-400 mt-1">쓸랭 관리자 전용 페이지</p>
        </div>

        {/* 로그인 폼 */}
        <form onSubmit={handleSubmit} className="space-y-4">
          {/* 이메일 입력 */}
          <div>
            <label className="block text-sm font-medium text-gray-300 mb-1.5">
              관리자 이메일
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="admin@sseulang.kr"
              className="w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-blue-500 transition-colors text-sm"
              autoComplete="email"
            />
          </div>

          {/* 비밀번호 입력 */}
          <div>
            <label className="block text-sm font-medium text-gray-300 mb-1.5">
              비밀번호
            </label>
            <div className="relative">
              <input
                type={showPw ? 'text' : 'password'}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••"
                className="w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-xl text-white placeholder-gray-500 focus:outline-none focus:border-blue-500 transition-colors text-sm pr-11"
                autoComplete="current-password"
              />
              {/* 비밀번호 표시/숨김 토글 버튼 */}
              <button
                type="button"
                onClick={() => setShowPw((prev) => !prev)}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-200 transition-colors"
                aria-label={showPw ? '비밀번호 숨기기' : '비밀번호 표시'}
              >
                {showPw ? <EyeOff size={18} /> : <Eye size={18} />}
              </button>
            </div>
          </div>

          {/* 에러 메시지 */}
          {error && (
            <p className="text-sm text-red-400 text-center">{error}</p>
          )}

          {/* 로그인 버튼 */}
          <button
            type="submit"
            disabled={isPending}
            className="w-full py-3 bg-blue-600 hover:bg-blue-500 disabled:opacity-50 text-white font-semibold rounded-xl transition-colors text-sm"
          >
            {isPending ? '로그인 중...' : '로그인'}
          </button>
        </form>

        {/* 개발 환경 테스트 계정 안내 */}
        {import.meta.env.VITE_MSW_ENABLED === 'true' && (
          <div className="mt-6 p-3 bg-gray-800 rounded-xl border border-gray-700">
            <p className="text-xs text-gray-400 text-center font-medium mb-1">
              테스트 계정 (Mock)
            </p>
            <p className="text-xs text-gray-500 text-center">
              admin@sseulang.kr / admin1234
            </p>
          </div>
        )}
      </div>
    </div>
  )
}
