// 거래 관리 페이지 컴포넌트 (UC-43: 보증금 반환 포함)
// 전체 거래 내역 조회, 결제 내역, 보증금 반환 처리

import { ArrowLeftRight } from 'lucide-react'  // Lucide 아이콘

// 거래 관리 페이지 컴포넌트
export default function AdminTradePage() {
  return (
    <div>
      {/* 페이지 헤더 */}
      <div className="mb-6">
        <div className="flex items-center gap-2 mb-1">
          <ArrowLeftRight size={20} className="text-gray-500" />
          <h1 className="text-xl font-bold text-gray-900">거래 관리</h1>
        </div>
        <p className="text-sm text-gray-500">
          전체 거래 내역 조회, 결제 내역, 보증금 반환 처리를 담당합니다. (UC-43)
        </p>
      </div>

      {/* 구현 예정 안내 */}
      <div className="bg-white rounded-2xl border border-gray-200 p-12 text-center">
        <ArrowLeftRight size={40} className="text-gray-300 mx-auto mb-3" />
        <p className="text-gray-400 text-sm font-medium">구현 예정</p>
        <p className="text-gray-300 text-xs mt-1">
          대여·구매·나눔 전체 거래 목록 · 결제 내역 · 보증금 반환 처리 기능이 추가될 예정입니다.
        </p>
      </div>
    </div>
  )
}
