---
to: <%= rootDirectory %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>SearchForm.vue
---
<template>
  <v-dialog v-model="syncedOpen" max-width="800px">
    <v-card :elevation="0">
      <v-card-title><%= struct.screenLabel || struct.name.pascalName %>検索</v-card-title>
      <v-card-text>
        <v-layout column>
      <%_ if (struct.fields) { -%>
      <%_ struct.fields.forEach(function (field, key) { -%>
        <%_ if ((field.dataType === 'string' || field.dataType === 'array-string' || field.dataType === 'textarea' || field.dataType === 'array-textarea') && field.searchType === 1) { -%>
          <v-text-field
            v-model="searchCondition.<%= field.name.lowerCamelName %>"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
          ></v-text-field>
        <%_ } -%>
        <%_ if ((field.dataType === 'number' || field.dataType === 'array-number') && field.searchType !== 0) { -%>
          <v-text-field
            :value="searchCondition.<%= field.name.lowerCamelName %>"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            type="number"
            @input="v => searchCondition.<%= field.name.lowerCamelName %> = v === '' ? undefined : Number(v)"
          ></v-text-field>
        <%_ } -%>
        <%_ if ((field.dataType === 'number' || field.dataType === 'array-number') && 2 <= field.searchType && field.searchType <= 5) { -%>
          <v-text-field
            :value="searchCondition.<%= field.name.lowerCamelName %>From"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>開始"
            type="number"
            @input="v => searchCondition.<%= field.name.lowerCamelName %>From = v === '' ? undefined : Number(v)"
          ></v-text-field>
          <v-text-field
            :value="searchCondition.<%= field.name.lowerCamelName %>To"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>終了"
            type="number"
            @input="v => searchCondition.<%= field.name.lowerCamelName %>To = v === '' ? undefined : Number(v)"
          ></v-text-field>
        <%_ } -%>
        <%_ if ((field.dataType === 'time' || field.dataType === 'array-time') && field.searchType !== 0) { -%>
          <date-time-form
            :date-time.sync="searchCondition.<%= field.name.lowerCamelName %>"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
          ></date-time-form>
        <%_ } -%>
        <%_ if ((field.dataType === 'time' || field.dataType === 'array-time') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
          <date-time-form
            :date-time.sync="searchCondition.<%= field.name.lowerCamelName %>From"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>開始"
          ></date-time-form>
          <date-time-form
            :date-time.sync="searchCondition.<%= field.name.lowerCamelName %>To"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>終了"
          ></date-time-form>
        <%_ } -%>
        <%_ if ((field.dataType === 'bool' || field.dataType === 'array-bool') && field.searchType === 1) { -%>
          <v-checkbox
            v-model="searchCondition.<%= field.name.lowerCamelName %>"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
          ></v-checkbox>
        <%_ } -%>
      <%_ }) -%>
      <%_ } -%>
        </v-layout>
      </v-card-text>
      <v-card-actions>
        <v-btn color="grey darken-1" text @click="close">キャンセル</v-btn>
        <v-spacer></v-spacer>
        <v-btn color="red darken-1" text @click="clear">クリア</v-btn>
        <v-spacer></v-spacer>
        <v-btn color="blue darken-1" text @click="search">検索</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script lang="ts">
import {cloneDeep} from 'lodash-es'
import {Component, Emit, mixins, Prop, PropSync, Watch} from 'nuxt-property-decorator'
import {Writable} from 'type-fest'
import {<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request} from '~/apis'
<%_ if (struct.exists.search.time || struct.exists.search.arrayTime) { -%>
import DateTimeForm from '~/components/form/DateTimeForm.vue'
<%_ } -%>
import {INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION} from '~/initials/<%= struct.name.pascalName %>Initials'
import Base from '~/mixins/base'

<%_ if (struct.exists.search.time || struct.exists.search.arrayTime) { -%>
@Component({
  components: {
    DateTimeForm,
  }
})
<%_ } else { -%>
@Component
<%_ } -%>
export default class <%= struct.name.pascalName %>SearchForm extends mixins(Base) {
  /** 表示状態 (true: 表示, false: 非表示) */
  @PropSync('open', {type: Boolean, required: true})
  syncedOpen!: boolean

  /** 検索条件 */
  @Prop({type: Object, required: true})
  currentSearchCondition!: Writable<<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request>

  /** 変更対象の検索条件 */
  searchCondition: Writable<<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request> = cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION)

  @Watch('syncedOpen')
  initialize() {
    if (this.syncedOpen) {
      const dialogElement = document.getElementsByClassName('v-dialog--active')?.[0]
      if (dialogElement) {
        dialogElement.scrollTop = 0
      }
      this.searchCondition = cloneDeep(this.currentSearchCondition)
    }
  }

  clear() {
    this.searchCondition = cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION)
    this.search()
  }

  close() {
    this.syncedOpen = false
  }

  @Emit('search')
  search() {
    this.close()
    return this.searchCondition
  }
}
</script>

<style scoped></style>
