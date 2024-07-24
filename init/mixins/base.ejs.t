---
to: <%= rootDirectory %>/mixins/base.ts
---
import dayjs from 'dayjs'
import {Component, Vue} from 'nuxt-property-decorator'
import appUtils from '~/utils/appUtils'

export interface VForm extends HTMLFormElement {
  reset(): void

  resetValidation(): void

  validate(): boolean
}

@Component
export default class Base extends Vue {
  formatISO(date?: string) {
    return dayjs(date).format()
  }

  formatDate(date?: string) {
    if (!date) {
      return ''
    }
    return dayjs(date).format('YYYY-MM-DD HH:mm')
  }

  toStringArray(array: any[]) {
    return appUtils.toStringArray(array)
  }

  toStringTimeArray(array: any[]) {
    return appUtils.toStringTimeArray(array)
  }
}
