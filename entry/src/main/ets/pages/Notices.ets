import router from '@ohos.router'

/** 公告数据结构（别用 type / 索引访问写法，兼容 ArkTSCheck） */
interface NoticeItem {
  id: number
  title: string
  content: string
  dept: string
  dateKey: string   // 例如 12/24
  weekDay: string   // 例如 周二
  tag: string       // 通知/考试/活动/教学/系统...
  read: number      // 0 未读 / 1 已读
}

/** 分组结构 */
interface NoticeGroup {
  key: string       // dateKey
  weekDay: string
  items: NoticeItem[]
}

/** ✅ 示例数据：确保“全部 / 未读 / 通知 / 考试 / 活动 / 教学”都有内容 */
const MOCK_NOTICES: NoticeItem[] = [
  { id: 101, title: '【考试】期末考试安排发布', content: '请进入教务系统查看个人考试时间与地点，按时参加。', dept: '教务处', dateKey: '12/24', weekDay: '周二', tag: '考试', read: 0 },
  { id: 102, title: '【教学】课程调停通知（离散数学）', content: '本周四离散数学调整到周五 10:00-11:35，上课地点 B105。', dept: '信息学院', dateKey: '12/24', weekDay: '周二', tag: '教学', read: 1 },
  { id: 103, title: '【通知】奖学金材料提交提醒', content: '请于本周五 17:00 前将材料交至辅导员处，逾期不候。', dept: '学工办', dateKey: '12/24', weekDay: '周二', tag: '通知', read: 0 },

  { id: 104, title: '【活动】红色主题打卡活动报名', content: '报名开启，名额有限。完成打卡可获纪念品。', dept: '团委', dateKey: '12/23', weekDay: '周一', tag: '活动', read: 0 },
  { id: 105, title: '【通知】图书馆闭馆时间调整', content: '本周起闭馆时间调整为 22:30，请合理安排学习时间。', dept: '图书馆', dateKey: '12/23', weekDay: '周一', tag: '通知', read: 1 },

  { id: 106, title: '【教学】实验课安全须知', content: '进入实验室请佩戴证件，禁止携带食品饮料，注意用电安全。', dept: '实验中心', dateKey: '12/22', weekDay: '周日', tag: '教学', read: 0 },
]

@Entry
@Component
struct Notices {
  @State keyword: string = ''
  @State activeTab: string = '全部'
  @State notices: NoticeItem[] = MOCK_NOTICES

  private searchIcon: Resource = $r('app.media.search')
  private readonly tabs: string[] = ['全部', '未读', '通知', '考试', '活动', '教学']

  private match(item: NoticeItem): boolean {
    if (this.activeTab === '未读' && item.read !== 0) return false
    if (this.activeTab !== '全部' && this.activeTab !== '未读' && item.tag !== this.activeTab) return false

    const k = this.keyword.trim()
    if (k.length === 0) return true
    return item.title.indexOf(k) >= 0 || item.dept.indexOf(k) >= 0 || item.content.indexOf(k) >= 0
  }

  private filteredList(): NoticeItem[] {
    const res: NoticeItem[] = []
    for (let i = 0; i < this.notices.length; i++) {
      const n = this.notices[i]
      if (this.match(n)) res.push(n)
    }
    return res
  }

  private groups(): NoticeGroup[] {
    const list = this.filteredList()
    const map = new Map<string, NoticeGroup>()

    for (let i = 0; i < list.length; i++) {
      const n = list[i]
      const key = n.dateKey
      let g = map.get(key)
      if (!g) {
        g = { key: key, weekDay: n.weekDay, items: [] }
        map.set(key, g)
      }
      g.items.push(n)
    }

    const keys: string[] = Array.from(map.keys())
    keys.sort((a: string, b: string) => (a < b ? 1 : -1))

    const out: NoticeGroup[] = []
    for (let i = 0; i < keys.length; i++) {
      const g = map.get(keys[i])
      if (g) out.push(g)
    }
    return out
  }

  private openDetail(id: number): void {
    // router.pushUrl({ url: 'pages/NoticeDetail', params: { id: id } })
  }

  build() {
    Column() {
      // ===== 顶部栏 =====
      Row() {
        Text('<')
          .fontSize(22)
          .width(36)
          .height(36)
          .textAlign(TextAlign.Center)
          .backgroundColor('#F3F4F6')
          .borderRadius(18)
          .onClick(() => router.back())

        Text('校园公告')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2937')

        Blank().width(36).height(36)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14 })

      // ===== 搜索框 =====
      Row() {
        Image(this.searchIcon)
          .width(22)
          .height(22)
          .margin({ left: 12, right: 6 })

        TextInput({ text: this.keyword, placeholder: '搜索公告/部门/关键词' })
          .layoutWeight(1)
          .height(40)
          .backgroundColor(Color.Transparent)
          .onChange((v: string) => {
            this.keyword = v
          })
      }
      .height(40)
      .width('92%')
      .backgroundColor('#F3F4F6')
      .borderRadius(20)
      .margin({ top: 14 })
      .alignSelf(ItemAlign.Center)

      // ===== Tab pills =====
      Row() {
        ForEach(this.tabs, (t: string) => {
          Text(t)
            .fontSize(12)
            .fontColor(t === this.activeTab ? '#1677FF' : '#6B7280')
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor(t === this.activeTab ? '#EAF2FF' : '#F3F4F6')
            .borderRadius(16)
            .margin({ right: 8 })
            .textAlign(TextAlign.Start)
            .onClick(() => {
              this.activeTab = t
            })
        }, (t: string) => t)
      }
      .width('92%')
      .margin({ top: 12 })
      .alignSelf(ItemAlign.Center)
      // ===== 列表区 =====
      List() {
        // 为空提示
        if (this.groups().length === 0) {
          ListItem() {
            Column() {
              Text('暂无内容')
                .fontSize(14)
                .fontColor('#9CA3AF')
                .margin({ top: 30 })
                .textAlign(TextAlign.Start)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center)
          }
        } else {
          ForEach(this.groups(), (g: NoticeGroup) => {
            // 日期头
            ListItem() {
              Row() {
                Text(g.key)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#111827')
                  .textAlign(TextAlign.Start)

                Text(`  ${g.weekDay}`)
                  .fontSize(12)
                  .fontColor('#6B7280')
                  .textAlign(TextAlign.Start)
              }
              .justifyContent(FlexAlign.Start)
              .alignItems(VerticalAlign.Center)
              .padding({ left: 16, right: 16, top: 14, bottom: 8 })
              .width('100%')
            }

            // 条目
            ForEach(g.items, (n: NoticeItem) => {
              ListItem() {
                Column() {
                  Row() {
                    Column() {
                      Blank().height(2)
                      Row() {
                        Blank().width(6).height(6)
                          .backgroundColor(n.read === 0 ? '#1677FF' : '#D1D5DB')
                          .borderRadius(3)
                      }
                    }
                    .width(14)
                    .alignItems(HorizontalAlign.Center)

                    Column() {
                      Row() {
                        Text(n.title)
                          .fontSize(15)
                          .fontWeight(n.read === 0 ? FontWeight.Bold : FontWeight.Medium)
                          .fontColor('#111827')
                          .maxLines(1)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                          .textAlign(TextAlign.Start)

                        Text(n.tag)
                          .fontSize(10)
                          .fontColor('#1677FF')
                          .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                          .backgroundColor('#EAF2FF')
                          .borderRadius(10)
                          .margin({ left: 8 })
                          .textAlign(TextAlign.Start)
                      }
                      .width('100%')
                      .justifyContent(FlexAlign.Start)
                      .alignItems(VerticalAlign.Center)

                      Text(n.dept + ' · ' + n.dateKey)
                        .fontSize(12)
                        .fontColor('#6B7280')
                        .margin({ top: 6 })
                        .textAlign(TextAlign.Start)

                      Text(n.content)
                        .fontSize(12)
                        .fontColor('#6B7280')
                        .maxLines(2)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .margin({ top: 6 })
                        .textAlign(TextAlign.Start)
                    }
                    .layoutWeight(1)
                    .width('100%')
                    .alignItems(HorizontalAlign.Start)
                  }
                  .width('100%')
                  .padding({ left: 16, right: 16, top: 10, bottom: 10 })
                  .onClick(() => this.openDetail(n.id))

                  Blank()
                    .height(1)
                    .width('100%')
                    .backgroundColor('#F3F4F6')
                }
                .width('100%')
                .alignItems(HorizontalAlign.Start)
              }
            }, (n: NoticeItem) => `${n.id}`)
          }, (g: NoticeGroup) => g.key)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .margin({ top: 6 })


    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
