// Guide.ets
import router from '@ohos.router'

interface SpotItem {
  id: number
  name: string
  desc: string
  pos: string
  hot: number
}

const MOCK_SPOTS: SpotItem[] = [
  { id: 1, name: '图书馆', desc: '自习/借阅/研讨室', pos: '学校中部', hot: 98 },
  { id: 2, name: '第一教学楼', desc: '常用上课区域', pos: '学校东侧', hot: 92 },
  { id: 3, name: '体育馆', desc: '运动/社团活动', pos: '学校南侧', hot: 88 },
  { id: 4, name: '食堂', desc: '早餐/午餐/晚餐', pos: '学校西侧', hot: 90 }
]

@Entry
@Component
struct Guide {
  private searchIcon: Resource = $r('app.media.search')
  private mapImg: Resource = $r('app.media.map')

  @State keyword: string = ''
  @State spots: SpotItem[] = MOCK_SPOTS
  @State destName: string = '图书馆'

  private match(s: SpotItem): boolean {
    const k = this.keyword.trim()
    if (k.length === 0) return true
    return s.name.indexOf(k) >= 0 || s.desc.indexOf(k) >= 0 || s.pos.indexOf(k) >= 0
  }

  private filteredSpots(): SpotItem[] {
    const out: SpotItem[] = []
    for (let i = 0; i < this.spots.length; i++) {
      if (this.match(this.spots[i])) out.push(this.spots[i])
    }
    return out
  }

  build() {
    Column() {
      /* ===== 顶部 ===== */
      Row() {
        Text('<')
          .width(42)
          .height(42)
          .textAlign(TextAlign.Center)
          .backgroundColor('#ffffffff')
          .borderRadius(18)
          .onClick(() => router.back())

        Text('校园导览')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Blank().width(36)
      }
      .padding({ left: 16, right: 16, top: 14 })

      /* ===== 搜索 ===== */
      Row() {
        Image(this.searchIcon)
          .width(16)
          .height(16)
          .margin({ left: 12, right: 8 })
          .opacity(0.6)

        TextInput({ text: this.keyword, placeholder: '搜索地点/建筑/关键词' })
          .layoutWeight(1)
          .height(42)
          .backgroundColor(Color.Transparent)
          .onChange(v => this.keyword = v)
      }
      .width('92%')
      .height(42)
      .backgroundColor('#F3F4F6')
      .borderRadius(12)
      .margin({ top: 12 })
      .alignSelf(ItemAlign.Center)

      /* ===== 地图 ===== */
      Stack() {
        Image(this.mapImg)
          .width('92%')
          .height(200)
          .borderRadius(16)
          .objectFit(ImageFit.Cover)

        Row() {
          Text('◎')
            .width(40)
            .height(40)
            .textAlign(TextAlign.Center)
            .fontColor(Color.White)
        }
        .width(40)
        .height(40)
        .backgroundColor('#00ffffe6')
        .borderRadius(20)
        .border({ width: 1, color: '#00e5e7eb' })
        .position({ x: '81%', y: 152 })
      }
      .margin({ top: 12 })

      /* ===== 推荐标题 ===== */
      Row() {
        Text('推荐地点')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)

        Text('（按热度）')
          .fontSize(12)
          .fontColor('#6B7280')
          .margin({ left: 6 })

        Blank().layoutWeight(1)

        Text('点击条目可设为终点')
          .fontSize(12)
          .fontColor('#9CA3AF')
      }
      .width('92%')
      .margin({ top: 12 ,bottom:12})
      .alignSelf(ItemAlign.Center)

      /* ===== 推荐列表（这里是你要改的重点） ===== */
      List() {
        ForEach(this.filteredSpots(), (s: SpotItem) => {
          ListItem() {
            Column() {
              Row() {

                /* ✅ 中间信息，直接左对齐 */
                Column() {
                  Row() {
                    Text(s.name)
                      .fontSize(15)
                      .fontWeight(FontWeight.Medium)

                    if (s.name === this.destName) {
                      Text('终点')
                        .fontSize(10)
                        .fontColor('#1677FF')
                        .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                        .backgroundColor('#EAF2FF')
                        .borderRadius(10)
                        .margin({ left: 8 })
                    }
                  }

                  Text(`${s.desc} · ${s.pos}`)
                    .fontSize(12)
                    .fontColor('#6B7280')
                    .margin({ top: 4 })
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                /* 右侧热度 */
                Column() {
                  Text(`${s.hot}`)
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                  Text('热度')
                    .fontSize(10)
                    .fontColor('#9CA3AF')
                }
                .alignItems(HorizontalAlign.End)
              }
              .width('92%')
              .alignSelf(ItemAlign.Center)
              .padding({ left: 16, right: 16, top: 10, bottom: 10 })
              .onClick(() => this.destName = s.name)

              Row() {}
              .width('92%')
              .height(1)
              .backgroundColor('#F3F4F6')
              .alignSelf(ItemAlign.Center)
            }
          }
        }, (s: SpotItem) => `${s.id}`)
      }
      .layoutWeight(1)

      /* ===== 路线信息 ===== */
      Column() {
        Row() {}
        .width(36)
        .height(4)
        .backgroundColor('#E5E7EB')
        .borderRadius(2)
        .alignSelf(ItemAlign.Center)
        .margin({ top: 10 })

        Column() {
          Text('路线信息')
            .fontWeight(FontWeight.Bold)

          Text('起点：当前位置')
            .fontSize(12)
            .margin({ top: 6 })

          Text(`终点：${this.destName}`)
            .fontSize(12)
            .margin({ top: 4 })

          Text('步行 12 分钟 · 0.9 km')
            .fontSize(12)
            .margin({ top: 4 })
        }
        .width('92%')
        .padding({ top: 10, bottom: 10 })
      }
      .borderRadius(14)
      .shadow({ radius: 12, color: '#00000010', offsetY: -2 })
      .margin({ left: 16, right: 16, bottom: 10 })

      /* ===== 底部按钮 ===== */
      Row() {
        Button('开始导航')
          .layoutWeight(1)
          .height(44)
          .backgroundColor('#ff4382d6')
          .fontColor(Color.White)
          .borderRadius(12)

        Button('换路线')
          .layoutWeight(1)
          .height(44)
          .backgroundColor('#ffeab377')
          .borderRadius(12)
          .margin({ left: 12 })
      }
      .width('92%')
      .padding({ bottom: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
