import 'package:flutter/widgets.dart';

/// Runtime translations for feature screens that are not generated from a
/// server. Values are keyed by stable English identifiers, so changing a
/// device language never requires rebuilding the navigation/router.
String uiText(BuildContext context, String key) {
  final locale = Localizations.localeOf(context).languageCode;
  const values = <String, Map<String, String>>{
    'settingsTitle': {'en': 'Settings', 'ja': '設定', 'zh': '设置', 'ko': '설정'},
    'language': {'en': 'Language', 'ja': '言語', 'zh': '语言', 'ko': '언어'},
    'currency': {'en': 'Currency', 'ja': '通貨', 'zh': '货币', 'ko': '통화'},
    'notifications': {
      'en': 'Notifications',
      'ja': '通知',
      'zh': '通知',
      'ko': '알림'
    },
    'backup': {
      'en': 'Backup & Restore',
      'ja': 'バックアップと復元',
      'zh': '备份与恢复',
      'ko': '백업 및 복원'
    },
    'deleteAll': {
      'en': 'Delete All Data',
      'ja': 'すべてのデータを削除',
      'zh': '删除所有数据',
      'ko': '모든 데이터 삭제'
    },
    'editUsername': {
      'en': 'Edit Username',
      'ja': 'ユーザー名を編集',
      'zh': '编辑用户名',
      'ko': '사용자 이름 편집'
    },
    'homeTitle': {'en': 'Home', 'ja': 'ホーム', 'zh': '首页', 'ko': '홈'},
    'todayProgress': {
      'en': "Today's Progress",
      'ja': '今日の進捗',
      'zh': '今日进度',
      'ko': '오늘의 진행률'
    },
    'addToDay': {
      'en': 'Add to this day',
      'ja': 'この日に追加',
      'zh': '添加到这一天',
      'ko': '이 날짜에 추가'
    },
    'viewDetails': {
      'en': 'View Item Details',
      'ja': 'アイテム詳細を見る',
      'zh': '查看项目详情',
      'ko': '항목 상세 보기'
    },
    'itemDetails': {
      'en': 'Item Details',
      'ja': 'アイテム詳細',
      'zh': '项目详情',
      'ko': '항목 상세'
    },
    'schedule': {'en': 'Schedule', 'ja': 'スケジュール', 'zh': '日程', 'ko': '일정'},
    'additionalInfo': {
      'en': 'Additional Information',
      'ja': '追加情報',
      'zh': '附加信息',
      'ko': '추가 정보'
    },
    'save': {'en': 'Save', 'ja': '保存', 'zh': '保存', 'ko': '저장'},
    'cancel': {'en': 'Cancel', 'ja': 'キャンセル', 'zh': '取消', 'ko': '취소'},
    'brand': {'en': 'Brand', 'ja': 'ブランド', 'zh': '品牌', 'ko': '브랜드'},
    'expiryDate': {
      'en': 'Expiry Date',
      'ja': '有効期限',
      'zh': '有效期',
      'ko': '사용 기한'
    },
    'usage': {
      'en': 'Usage Instructions',
      'ja': '使用方法',
      'zh': '使用说明',
      'ko': '사용 방법'
    },
    'size': {'en': 'Size', 'ja': 'サイズ', 'zh': '尺寸', 'ko': '크기'},
    'price': {'en': 'Price', 'ja': '価格', 'zh': '价格', 'ko': '가격'},
    'shelfNumber': {
      'en': 'Shelf Number',
      'ja': '棚番号',
      'zh': '货架编号',
      'ko': '선반 번호'
    },
    'all': {'en': 'All', 'ja': 'すべて', 'zh': '全部', 'ko': '전체'},
    'morning': {'en': 'Morning', 'ja': '朝', 'zh': '早晨', 'ko': '아침'},
    'afternoon': {'en': 'Afternoon', 'ja': '午後', 'zh': '下午', 'ko': '오후'},
    'evening': {'en': 'Evening', 'ja': '夕方', 'zh': '晚上', 'ko': '저녁'},
    'anytime': {'en': 'Anytime', 'ja': 'いつでも', 'zh': '任何时间', 'ko': '언제든지'},
  };
  return values[key]?[locale] ?? values[key]?['en'] ?? key;
}
