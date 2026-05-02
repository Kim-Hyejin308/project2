// 브랜드 입점 문의 관리 페이지 컴포넌트 (UC-46)
// 브랜드의 입점 문의를 검토하고 응대하는 관리자 기능

import { Building2 } from 'lucide-react'  // Lucide 아이콘

// 브랜드 입점 문의 관리 페이지 컴포넌트
export default function AdminBrandsPage() {
  return (
    <div>
      {/* 페이지 헤더 */}
      <div className="mb-6">
        <div className="flex items-center gap-2 mb-1">
          <Building2 size={20} className="text-gray-500" />
          <h1 className="text-xl font-bold text-gray-900">브랜드 입점 문의</h1>
        </div>
        <p className="text-sm text-gray-500">브랜드사의 입점 문의를 검토하고 응대합니다. (UC-46)</p>
      </div>

      {/* 구현 예정 안내 */}
      <div className="bg-white rounded-2xl border border-gray-200 p-12 text-center">
        <Building2 size={40} className="text-gray-300 mx-auto mb-3" />
        <p className="text-gray-400 text-sm font-medium">구현 예정</p>
        <p className="text-gray-300 text-xs mt-1">
          브랜드 문의 목록 · 검토 상태 변경 · 담당자 응대 기능이 추가될 예정입니다.
        </p>
      </div>
    </div>
  )
}
