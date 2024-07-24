---
to: <%= rootDirectory %>/components/form/DateTimeForm.vue
force: true
---
<template>
  <v-layout>
    <v-flex xs6>
      <v-menu v-model="dateMenu" :close-on-content-click="false" max-width="290">
        <template #activator="{ on, attrs }">
          <v-text-field :clearable="clearable" :disabled="disabled" :label="label" :value="displayDate"
                        prepend-icon="mdi-calendar" readonly
                        v-bind="attrs" v-on="on"
                        @click:prepend="dateValue = null"
                        @click:clear="clearDate"></v-text-field>
        </template>
        <v-date-picker v-model="dateValue" :disabled="disabled"
                       @change="dateMenu = false"></v-date-picker>
      </v-menu>
    </v-flex>
    <v-flex v-if="!onlyDate" xs6>
      <v-menu v-model="timeMenu" :close-on-content-click="false" max-width="290px">
        <template #activator="{ on, attrs }">
          <v-text-field :clearable="clearable" :disabled="disabled" :value="displayTime"
                        prepend-icon="mdi-clock-outline" readonly
                        v-bind="attrs" v-on="on"
                        @click:prepend="timeValue = null"
                        @click:clear="clearTime"></v-text-field>
        </template>
        <v-time-picker v-if="timeMenu"
                       v-model="timeValue" :disabled="disabled"
                       @click:minute="timeMenu = false"></v-time-picker>
      </v-menu>
    </v-flex>
  </v-layout>
</template>

<script lang="ts">
import dayjs, {Dayjs} from 'dayjs'
import customParseFormat from 'dayjs/plugin/customParseFormat'
import {Component, Prop, PropSync, Vue} from 'nuxt-property-decorator'

dayjs.extend(customParseFormat)

@Component
export default class DateTimeFrom extends Vue {
  /** 表示用のFormat */
  readonly DISPLAY_DATE_FORMAT = 'YYYY/MM/DD'
  readonly DISPLAY_TIME_FORMAT = 'HH:mm'
  /** PickerのValueに対応したFormat */
  readonly DATE_PICKER_FORMAT = 'YYYY-MM-DD'
  readonly TIME_PICKER_FORMAT = 'HH:mm'

  /** 画面表示ラベル */
  @Prop({type: String, default: ''})
  label!: string

  /** 編集対象 */
  @PropSync('dateTime', {type: String, default: undefined})
  syncedDateTime: string | undefined = undefined

  /** 編集状態 (true: 編集不可, false: 編集可能) */
  @Prop({type: Boolean, default: false})
  disabled!: boolean

  /** 時刻表示状態 (true: 日付のみ, false: 日付と時刻) */
  @Prop({type: Boolean, default: false})
  onlyDate!: boolean

  /** クリア操作可否 (true: クリア可能, false: クリア不可) */
  @Prop({type: Boolean, default: false})
  clearable!: boolean

  /** 日付選択表示状態 (true: 表示, false: 非表示) */
  dateMenu = false

  /** 時刻選択表示状態 (true: 表示, false: 非表示) */
  timeMenu = false

  get dayjsDateTime(): Dayjs {
    return dayjs(this.syncedDateTime)
  }

  get displayDate(): string {
    if (!this.syncedDateTime) {
      return ''
    }
    return this.dayjsDateTime.format(this.DISPLAY_DATE_FORMAT)
  }

  get dateValue(): string | null {
    if (!this.syncedDateTime) {
      return null
    }
    return this.dayjsDateTime.format(this.DATE_PICKER_FORMAT)
  }

  set dateValue(dateValue: string | null) {
    let dateTime = dateValue ? dayjs(dateValue, this.DATE_PICKER_FORMAT) : dayjs()
    if (this.syncedDateTime) {
      dateTime = dateTime.hour(this.dayjsDateTime.hour()).minute(this.dayjsDateTime.minute())
    }
    this.syncedDateTime = dateTime.format()
  }

  get displayTime(): string {
    if (!this.syncedDateTime) {
      return ''
    }
    return this.dayjsDateTime.format(this.DISPLAY_TIME_FORMAT)
  }

  get timeValue(): string | null {
    if (!this.syncedDateTime) {
      return null
    }
    return this.dayjsDateTime.format(this.TIME_PICKER_FORMAT)
  }

  set timeValue(timeValue: string | null) {
    let dateTime = timeValue ? dayjs(timeValue, this.TIME_PICKER_FORMAT) : dayjs()
    if (this.syncedDateTime) {
      dateTime = dateTime.year(this.dayjsDateTime.year()).month(this.dayjsDateTime.month()).date(this.dayjsDateTime.date())
    }
    this.syncedDateTime = dateTime.format()
  }

  clearDate() {
    this.syncedDateTime = undefined
  }

  clearTime() {
    if (!this.syncedDateTime) {
      return
    }
    this.syncedDateTime = this.dayjsDateTime.startOf('day').format()
  }
}
</script>

<style scoped></style>
