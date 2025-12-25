import router from '@ohos.router'
import promptAction from '@ohos.promptAction'

type CourseTag = '必修' | '选修' | '实验' | '线上'

interface CourseItem {
  id: number
  name: string
  place: string
  start: string
  end: string
  section: number
  tag: CourseTag
}

const DAYS: string[] = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']

function tagBg(tag: CourseTag): string {
  switch (tag) {
    case '必修': return '#EAF2FF'
    case '选修': return '#E9FBF1'
    case '实验': return '#FFF2E7'
    case '线上': return '#F3E9FF'
    default: return '#F5F6F7'
  }
}

function tagText(tag: CourseTag): string {
  switch (tag) {
    case '必修': return '#1677FF'
    case '选修': return '#22C55E'
    case '实验': return '#F59E0B'
    case '线上': return '#8B5CF6'
    default: return '#6B7280'
  }
}

const MOCK: Record<number, CourseItem[]> = {
  0: [
    { id: 1, name: '数据结构', place: 'A203', start: '08:00', end: '09:35', section: 1, tag: '必修' },
    { id: 2, name: '离散数学', place: 'B105', start: '10:00', end: '11:35', section: 2, tag: '必修' },
    { id: 3, name: '形势与政策', place: '线上', start: '14:00', end: '15:35', section: 5, tag: '线上' }
  ],
  1: [
    { id: 4, name: '操作系统', place: 'A401', start: '08:00', end: '09:35', section: 1, tag: '必修' },
    { id: 5, name: '数据库原理', place: 'C210', start: '10:00', end: '11:35', section: 2, tag: '必修' }
  ],
  2: [
    { id: 6, name: '英语（六级）', place: 'D108', start: '10:00', end: '11:35', section: 2, tag: '选修' },
    { id: 7, name: '软件工程导论', place: 'A305', start: '14:00', end: '15:35', section: 5, tag: '必修' }
  ],
  3: [
    { id: 8, name: '嵌入式系统实验', place: '实验楼 2F', start: '13:00', end: '15:35', section: 5, tag: '实验' }
  ],
  4: [
    { id: 9, name: '编译原理', place: 'B209', start: '08:00', end: '09:35', section: 1, tag: '必修' },
    { id: 10, name: '算法设计', place: 'A206', start: '10:00', end: '11:35', section: 2, tag: '必修' }
  ],
  5: [],
  6: []
}

@Entry
@Component
struct Timetable {
  @State selectedDay: number = 0
  @State weekNo: number = 16
  @State dateLabel: string = '12/24'
  @State dayList: CourseItem[] = []

  aboutToAppear() {
    this.refreshList()
  }

  private refreshList(): void {
    this.dayList = MOCK[this.selectedDay] ?? []
  }

  private toast(msg: string): void {
    try { promptAction.showToast({ message: msg }) } catch (e) {}
  }

  private back(): void {
    try { router.back() } catch (e) {}
  }

  private openAction(): void {
    this.toast('筛选/设置（演示）')
  }

  private prevWeek(): void {
    if (this.weekNo > 1) this.weekNo--
  }

  private nextWeek(): void {
    this.weekNo++
  }

  private summaryText(): string {
    if (this.dayList.length === 0) return '今日无课程安排'
    const next = this.dayList[0]
    return `共 ${this.dayList.length} 节课 · 下一节 ${next.start} ${next.name}`
  }

  build() {
    Column() {
      // ================== 顶部固定区 ==================
      Column() {
        // 顶部栏
        Row() {
          Column() {
            Text('←')
              .fontSize(18)
              .width(36)
              .height(36)
              .textAlign(TextAlign.Center)
              .backgroundColor('#F3F4F6')
              .borderRadius(18)
          }
          .onClick(() => this.back())

          Text('课程表')
            .layoutWeight(1)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#111827')
            .textAlign(TextAlign.Center)

          Column() {
            Image($r('app.media.setting'))
              .width(30)
              .height(30)
              .padding(4)
              .backgroundColor('#FFFFFF')
              .borderRadius(19)
              .onClick(() => {
                // TODO：跳转设置页
              })
          }
          }
        .width('100%')
        .padding({ left: 18, right: 18, top: 10 })

        // 周次/日期 + 切换周
        Row() {
          Column() {
            Text(`本周第 ${this.weekNo} 周`)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#111827')
            Text(`Mon ${this.dateLabel}`)
              .fontSize(12)
              .fontColor('#6B7280')
              .margin({ top: 4 })
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)

          Row() {
            Text('‹')
              .fontSize(18)
              .width(32)
              .height(32)
              .textAlign(TextAlign.Center)
              .backgroundColor('#F3F4F6')
              .borderRadius(16)
              .onClick(() => this.prevWeek())

            Text('›')
              .fontSize(18)
              .width(32)
              .height(32)
              .textAlign(TextAlign.Center)
              .backgroundColor('#F3F4F6')
              .borderRadius(16)
              .margin({ left: 10 })
              .onClick(() => this.nextWeek())
          }
        }
        .width('100%')
        .padding({ left: 18, right: 18, top: 8 })

        // 星期Tab
        Scroll() {
          Row() {
            ForEach(DAYS, (d: string, idx: number) => {
              DayPill({ text: d, active: this.selectedDay === idx })
                .margin({ right: 10 })
                .onClick(() => {
                  this.selectedDay = idx
                  this.refreshList()
                })
            })
          }
          .padding({ left: 18, right: 18, top: 8, bottom: 6 })
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)

        // 今日概览（固定，不随列表变化移动）
        Column() {
          Text('今日概览')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#111827')

          Text(this.summaryText())
            .fontSize(12)
            .fontColor('#6B7280')
            .margin({ top: 8 })

          if (this.dayList.length > 0) {
            Text(`上课地点：${this.dayList[0].place}`)
              .fontSize(12)
              .fontColor('#6B7280')
              .margin({ top: 6 })
          }
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#F9FAFB')
        .borderRadius(18)
        .margin({ left: 18, right: 18, top: 10 })
      }

      // ================== 中间：仅课程列表滚动（锁定容器） ==================
      Column() {
        Row() {
          Text('今日课程')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#111827')
            .layoutWeight(1)

          Text(DAYS[this.selectedDay])
            .fontSize(12)
            .fontColor('#6B7280')
        }
        .padding({ left: 18, right: 18, top: 12, bottom: 6 })

        // ✅ 这里用 List，占满中间容器，课程多少不影响上下其它元素位置
        List() {
          if (this.dayList.length === 0) {
            ListItem() {
              EmptyPanel()
                .margin({ left: 18, right: 18, top: 6 })
            }
          } else {
            ForEach(this.dayList, (c: CourseItem) => {
              ListItem() {
                CourseCard({ item: c })
                  .margin({ left: 18, right: 18, top: 10 })
                  .onClick(() => this.toast(`进入「${c.name}」详情（演示）`))
              }
            })
          }
          // 底部留点空，避免最后一个卡片贴到底部栏
          ListItem() {
            Column() {
              Blank().height(90)
            }
          }

        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)
      }
      .layoutWeight(1)

      // ================== 底部固定操作栏（锁定不动） ==================
      Row() {
        Button('+ 添加课程')
          .height(44)
          .backgroundColor('#1677FF')
          .fontColor(Color.White)
          .borderRadius(12)
          .layoutWeight(1)
          .onClick(() => this.toast('添加课程（演示）'))

        Button('导入/导出')
          .height(44)
          .backgroundColor('#F3F4F6')
          .fontColor('#111827')
          .borderRadius(12)
          .layoutWeight(1)
          .margin({ left: 12 })
          .onClick(() => this.toast('导入/导出（演示）'))
      }
      .width('100%')
      .padding({ left: 18, right: 18, top: 10, bottom: 12 })
      .backgroundColor('#FFFFFF')
      .border({ width: { top: 1 }, color: '#EEF0F2' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}

@Component
struct DayPill {
  @Prop text: string
  @Prop active: boolean

  build() {
    Text(this.text)
      .fontSize(12)
      .fontColor(this.active ? '#1677FF' : '#6B7280')
      .padding({ left: 14, right: 14, top: 8, bottom: 8 })
      .backgroundColor(this.active ? '#EAF2FF' : '#F3F4F6')
      .borderRadius(18)
  }
}

@Component
struct CourseCard {
  @Prop item: CourseItem

  build() {
    Row() {
      // 左侧节次
      Column() {
        Text(`${this.item.section}`)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#111827')
      }
      .width(44)
      .height(44)
      .backgroundColor('#FFFFFF')
      .borderRadius(14)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)

      // ✅ 右侧信息：强制靠左
      Column() {
        Row() {
          Text(this.item.name)
            .width('100%')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#111827')
            .textAlign(TextAlign.Start)

          Text('›')
            .fontSize(20)
            .fontColor('#9CA3AF')
        }
        .width('100%')

        Text(`${this.item.start}-${this.item.end} · ${this.item.place}`)
          .width('100%')
          .fontSize(12)
          .fontColor('#6B7280')
          .textAlign(TextAlign.Start)
          .margin({ top: 6 })

        Text(this.item.tag)
          .fontSize(11)
          .fontColor(tagText(this.item.tag))
          .padding({ left: 10, right: 10, top: 4, bottom: 4 })
          .backgroundColor('#FFFFFF')
          .borderRadius(10)
          .margin({ top: 8 })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start) // ✅ 关键：整体靠左
      .margin({ left: 12 })
      .layoutWeight(1)
    }
    .padding(16)
    .backgroundColor(tagBg(this.item.tag))
    .borderRadius(18)
    .shadow({ radius: 10, color: '#12000000', offsetX: 0, offsetY: 6 })
  }
}

@Component
struct EmptyPanel {
  build() {
    Column() {
      Text('🎉').fontSize(28)
      Text('今天没有课程')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#111827')
        .margin({ top: 8 })
      Text('好好休息一下，或点击下方添加课程')
        .fontSize(12)
        .fontColor('#6B7280')
        .margin({ top: 6 })
    }
    .width('100%')
    .padding(18)
    .backgroundColor('#F9FAFB')
    .borderRadius(18)
    .alignItems(HorizontalAlign.Center)
  }
}
