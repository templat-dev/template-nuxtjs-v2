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
        <%_ if ((field.listType === 'string' || field.listType === 'array-string' || field.listType === 'textarea' || field.listType === 'array-textarea') && field.searchType === 1) { -%>
          <v-text-field
            v-model="searchCondition.<%= field.name.lowerCamelName %>"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
          ></v-text-field>
        <%_ } -%>
        <%_ if ((field.listType === 'number' || field.listType === 'array-number') && field.searchType !== 0) { -%>
          <v-text-field
            :value="searchCondition.<%= field.name.lowerCamelName %>"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
            type="number"
            @input="v => searchCondition.<%= field.name.lowerCamelName %> = v === '' ? undefined : Number(v)"
          ></v-text-field>
        <%_ } -%>
        <%_ if ((field.listType === 'number' || field.listType === 'array-number') && 2 <= field.searchType && field.searchType <= 5) { -%>
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
        <%_ if ((field.listType === 'time' || field.listType === 'array-time') && field.searchType !== 0) { -%>
          <date-time-form
            :date-time.sync="searchCondition.<%= field.name.lowerCamelName %>"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>"
          ></date-time-form>
        <%_ } -%>
        <%_ if ((field.listType === 'time' || field.listType === 'array-time') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
          <date-time-form
            :date-time.sync="searchCondition.<%= field.name.lowerCamelName %>From"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>開始"
          ></date-time-form>
          <date-time-form
            :date-time.sync="searchCondition.<%= field.name.lowerCamelName %>To"
            label="<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName %>終了"
          ></date-time-form>
        <%_ } -%>
        <%_ if ((field.listType === 'bool' || field.listType === 'array-bool') && field.searchType === 1) { -%>
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
<%_ const searchConditions = [] -%>
<%_ if (struct.fields && struct.fields.length > 0) { -%>
<%_ struct.fields.forEach(function (field, key) { -%>
  <%_ if ((field.listType === 'string' || field.listType === 'array-string' || field.listType === 'time' || field.listType === 'array-time') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'string', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'bool' || field.listType === 'array-bool') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'boolean', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'number' || field.listType === 'array-number') && field.searchType === 1) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'number', range: false}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'number' || field.listType === 'array-number') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'number', range: true}) -%>
  <%_ } -%>
  <%_ if ((field.listType === 'time' || field.listType === 'array-time') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
    <%_ searchConditions.push({name: field.name.lowerCamelName, type: 'string', range: true}) -%>
  <%_ } -%>
<%_ }) -%>
<%_ } -%>
import {Component, Emit, mixins, Prop, PropSync, Watch} from 'nuxt-property-decorator'
import {cloneDeep} from 'lodash-es'
import {Writable} from 'type-fest'
import Base from '@/mixins/base'
import {<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request} from '@/apis'
<%_ if (struct.exists.search.time || struct.exists.search.arrayTime) { -%>
import DateTimeForm from '@/components/form/DateTimeForm.vue'
<%_ } -%>

export const INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION: Writable<<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request> = {
  <%_ searchConditions.forEach(function(searchCondition) { -%>
    <%_ if (searchCondition.type === 'string' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'boolean' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && !searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'number' && searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
  <%= searchCondition.name %>From: undefined,
  <%= searchCondition.name %>To: undefined,
    <%_ } -%>
    <%_ if (searchCondition.type === 'string' && searchCondition.range) { -%>
  <%= searchCondition.name %>: undefined,
  <%= searchCondition.name %>From: undefined,
  <%= searchCondition.name %>To: undefined,
    <%_ } -%>
  <%_ }) -%>
}

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
