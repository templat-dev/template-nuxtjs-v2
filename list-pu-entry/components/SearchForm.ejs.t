---
to: <%= rootDirectory %>/<%= projectName %>/components/<%= entity.name %>/<%= h.changeCase.pascal(entity.name) %>SearchForm.vue
---
<template>
  <v-dialog v-model="syncedOpen" max-width="800px">
    <v-card :elevation="0">
      <v-card-title><%= h.changeCase.pascal(entity.name) %>検索</v-card-title>
      <v-card-text>
        <v-layout column>
      <%_ if (entity.listProperties.listExtraProperties) { -%>
      <%_ entity.listProperties.listExtraProperties.forEach(function (property, key) { -%>
        <%_ if ((property.type === 'string' || property.type === 'array-string' || property.type === 'textarea' || property.type === 'array-textarea') && property.searchType === 1) { -%>
          <v-text-field
            v-model="searchCondition.<%= property.name %>"
            label="<%= property.screenLabel ? property.screenLabel : property.name %>"
          ></v-text-field>
        <%_ } -%>
        <%_ if ((property.type === 'number' || property.type === 'array-number') && property.searchType !== 0) { -%>
          <v-text-field
            :value="searchCondition.<%= property.name %>"
            label="<%= property.screenLabel ? property.screenLabel : property.name %>"
            type="number"
            @input="v => searchCondition.<%= property.name %> = v === '' ? undefined : Number(v)"
          ></v-text-field>
        <%_ } -%>
        <%_ if ((property.type === 'number' || property.type === 'array-number') && 2 <= property.searchType && property.searchType <= 5) { -%>
          <v-text-field
            :value="searchCondition.<%= property.name %>From"
            label="<%= property.screenLabel ? property.screenLabel : property.name %>開始"
            type="number"
            @input="v => searchCondition.<%= property.name %>From = v === '' ? undefined : Number(v)"
          ></v-text-field>
          <v-text-field
            :value="searchCondition.<%= property.name %>To"
            label="<%= property.screenLabel ? property.screenLabel : property.name %>終了"
            type="number"
            @input="v => searchCondition.<%= property.name %>To = v === '' ? undefined : Number(v)"
          ></v-text-field>
        <%_ } -%>
        <%_ if ((property.type === 'time' || property.type === 'array-time') && property.searchType !== 0) { -%>
          <date-time-form
            :date-time.sync="searchCondition.<%= property.name %>"
            label="<%= property.screenLabel ? property.screenLabel : property.name %>"
          ></date-time-form>
        <%_ } -%>
        <%_ if ((property.type === 'time' || property.type === 'array-time') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
          <date-time-form
            :date-time.sync="searchCondition.<%= property.name %>From"
            label="<%= property.screenLabel ? property.screenLabel : property.name %>開始"
          ></date-time-form>
          <date-time-form
            :date-time.sync="searchCondition.<%= property.name %>To"
            label="<%= property.screenLabel ? property.screenLabel : property.name %>終了"
          ></date-time-form>
        <%_ } -%>
        <%_ if ((property.type === 'bool' || property.type === 'array-bool') && property.searchType === 1) { -%>
          <v-checkbox
            v-model="searchCondition.<%= property.name %>"
            label="<%= property.screenLabel ? property.screenLabel : property.name %>"
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
<%_ let importDateTime = false -%>
<%_ if (entity.listProperties.listExtraProperties && entity.listProperties.listExtraProperties.length > 0) { -%>
<%_ entity.listProperties.listExtraProperties.forEach(function (property, key) { -%>
  <%_ if ((property.type === 'string' || property.type === 'array-string' || property.type === 'time' || property.type === 'array-time') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name, type: 'string', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.type === 'bool' || property.type === 'array-bool') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name, type: 'boolean', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.type === 'number' || property.type === 'array-number') && property.searchType === 1) { -%>
    <%_ searchConditions.push({name: property.name, type: 'number', range: false}) -%>
  <%_ } -%>
  <%_ if ((property.type === 'number' || property.type === 'array-number') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
    <%_ searchConditions.push({name: property.name, type: 'number', range: true}) -%>
  <%_ } -%>
  <%_ if ((property.type === 'time' || property.type === 'array-time') && 2 <= property.searchType &&  property.searchType <= 5) { -%>
    <%_ searchConditions.push({name: property.name, type: 'string', range: true}) -%>
  <%_ } -%>
  <%_ if ((property.type === 'time' || property.type === 'array-time')) { -%>
  <%_ importDateTime = true -%>
  <%_ } -%>
<%_ }) -%>
<%_ } -%>
import {Component, Emit, mixins, Prop, PropSync, Watch} from 'nuxt-property-decorator'
import {cloneDeep} from 'lodash-es'
import Base from '@/mixins/base'
<%_ if (importDateTime) { -%>
import DateTimeForm from '@/components/form/DateTimeForm.vue'
<%_ } -%>

<%_ if (searchConditions.length > 0) { -%>
export interface <%= h.changeCase.pascal(entity.name) %>SearchCondition {
  <%_ searchConditions.forEach(function(property) { -%>
    <%_ if (property.type === 'string' && !property.range) { -%>
  <%= property.name %>?: <%= property.type %>
    <%_ } -%>
    <%_ if (property.type === 'boolean' && !property.range) { -%>
  <%= property.name %>?: <%= property.type %>
    <%_ } -%>
    <%_ if (property.type === 'number' && !property.range) { -%>
  <%= property.name %>?: <%= property.type %>
    <%_ } -%>
    <%_ if (property.type === 'number' && property.range) { -%>
  <%= property.name %>?: <%= property.type %>
  <%= property.name %>From?: <%= property.type %>
  <%= property.name %>To?: <%= property.type %>
    <%_ } -%>
    <%_ if (property.type === 'string' && property.range) { -%>
  <%= property.name %>?: <%= property.type %>
  <%= property.name %>From?: <%= property.type %>
  <%= property.name %>To?: <%= property.type %>
    <%_ } -%>
  <%_ }) -%>
}

export const INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION: <%= h.changeCase.pascal(entity.name) %>SearchCondition = {
  <%_ searchConditions.forEach(function(property) { -%>
    <%_ if (property.type === 'string' && !property.range) { -%>
  <%= property.name %>: undefined,
    <%_ } -%>
    <%_ if (property.type === 'boolean' && !property.range) { -%>
  <%= property.name %>: undefined,
    <%_ } -%>
    <%_ if (property.type === 'number' && !property.range) { -%>
  <%= property.name %>: undefined,
    <%_ } -%>
    <%_ if (property.type === 'number' && property.range) { -%>
  <%= property.name %>: undefined,
  <%= property.name %>From: undefined,
  <%= property.name %>To: undefined,
    <%_ } -%>
    <%_ if (property.type === 'string' && property.range) { -%>
  <%= property.name %>: undefined,
  <%= property.name %>From: undefined,
  <%= property.name %>To: undefined,
    <%_ } -%>
  <%_ }) -%>
}
<%_ } else { -%>
export interface <%= h.changeCase.pascal(entity.name) %>SearchCondition {
}

export const INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION: <%= h.changeCase.pascal(entity.name) %>SearchCondition = {}
<%_ } -%>

<%_ if (importDateTime) { -%>
@Component({
  components: {
    DateTimeForm,
  }
})
<%_ } else { -%>
@Component
<%_ } -%>
export default class <%= h.changeCase.pascal(entity.name) %>SearchForm extends mixins(Base) {
  /** 表示状態 (true: 表示, false: 非表示) */
  @PropSync('open', {type: Boolean, required: true})
  syncedOpen!: boolean

  /** 検索条件 */
  @Prop({type: Object, required: true})
  currentSearchCondition!: <%= h.changeCase.pascal(entity.name) %>SearchCondition

  /** 変更対象の検索条件 */
  searchCondition: <%= h.changeCase.pascal(entity.name) %>SearchCondition = cloneDeep(INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION)

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
    this.searchCondition = cloneDeep(INITIAL_<%= h.changeCase.constant(entity.name) %>_SEARCH_CONDITION)
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
