---
to: <%= rootDirectory %>/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>DataTable.vue
---
<template>
  <v-flex>
    <app-data-table
      :headers="headers"
      :is-loading="isLoading"
      :items="items || []"
      :items-per-page="syncedPageInfo.itemsPerPage"
      :page-info.sync="syncedPageInfo"
      :total-count="totalCount"
      loading-text="読み込み中"
      no-data-text="該当データ無し"
      @clickRow="clickRow"
      @onChangePageInfo="onChangePageInfo">
      <!-- ヘッダー -->
      <template #top>
        <v-toolbar color="white" flat>
          <v-toolbar-title><%= struct.screenLabel || struct.name.pascalName %>一覧</v-toolbar-title>
<%_ if (struct.structType !== 'struct') { -%>
          <template v-if="!hasParent">
            <v-divider class="mx-4" inset vertical></v-divider>
            <v-btn icon @click="isSearchFormOpen = true">
              <v-icon>mdi-magnify</v-icon>
            </v-btn>
            <span>{{ previewSearchCondition }}</span>
          </template>
<%_ } -%>
          <v-spacer></v-spacer>
          <v-btn class="action-button" color="primary" dark fab right small top @click="clickAdd">
            <v-icon>mdi-plus</v-icon>
          </v-btn>
        </v-toolbar>
      </template>
<%_ if (struct.fields) { -%>
<%_ struct.fields.forEach(function(field, index){ -%>
<%_ if (field.listType === 'time' || field.listType === 'time-range') { -%>
      <template #item.<%= field.name.lowerCamelName %>="{ item }">
        <span>{{ formatDate(item.<%= field.name.lowerCamelName %>) }}</span>
      </template>
<%_ } -%>
<%_ if (field.listType === 'bool') { -%>
      <template #item.<%= field.name.lowerCamelName %>="{ item }">
        <v-checkbox v-model="item.<%= field.name.lowerCamelName %>" :ripple="false" class="ma-0 pa-0" hide-details readonly></v-checkbox>
      </template>
<%_ } -%>
<%_ if (field.listType === 'array-string' || field.listType === 'array-number' || field.listType === 'array-bool') { -%>
      <template #item.<%= field.name.lowerCamelName %>="{ item }">
        <span>{{ toStringArray(item.<%= field.name.lowerCamelName %>) }}</span>
      </template>
<%_ } -%>
<%_ if (field.listType === 'array-time') { -%>
      <template #item.<%= field.name.lowerCamelName %>="{ item }">
        <span>{{ toStringTimeArray(item.<%= field.name.lowerCamelName %>) }}</span>
      </template>
<%_ } -%>
<%_ if (field.listType === 'image' && field.dataType === 'string') { -%>
      <template #item.<%= field.name.lowerCamelName %>="{ item }">
        <v-img :src="item.<%= field.name.lowerCamelName %>" max-height="100px" max-width="100px"></v-img>
      </template>
<%_ } -%>
<%_ if (field.listType === 'array-image') { -%>
      <template #item.<%= field.name.lowerCamelName %>="{ item }">
        <v-carousel
          v-if="item.<%= field.name.lowerCamelName %> && item.<%= field.name.lowerCamelName %>.length > 0"
          class="carousel" height="100px" hide-delimiters>
          <template #prev="{ on, attrs }">
            <v-btn v-bind="attrs" v-on="on" icon x-small>
              <v-icon>mdi-chevron-left</v-icon>
            </v-btn>
          </template>
          <template #next="{ on, attrs }">
            <v-btn v-bind="attrs" v-on="on" icon x-small>
              <v-icon>mdi-chevron-right</v-icon>
            </v-btn>
          </template>
          <v-carousel-item v-for="(image,i) in item.<%= field.name.lowerCamelName %>" :key="i">
            <v-layout justify-center>
              <v-img :src="image" contain max-height="100px" max-width="100px"/>
            </v-layout>
          </v-carousel-item>
        </v-carousel>
      </template>
<%_ } -%>
<%_ }); -%>
<%_ } -%>
      <!-- 行操作列 -->
      <template #item.action="{ item }">
        <v-btn icon @click.stop="remove(item)">
          <v-icon>mdi-delete</v-icon>
        </v-btn>
      </template>
    </app-data-table>
<%_ if (struct.structType !== 'struct') { -%>
    <<%= struct.name.pascalName %>SearchForm
      :current-search-condition="syncedSearchCondition"
      :open.sync="isSearchFormOpen"
      @search="search"
    ></<%= struct.name.pascalName %>SearchForm>
<%_ } -%>
  </v-flex>
</template>

<script lang="ts">
import {cloneDeep} from 'lodash-es'
import {Component, Emit, mixins, Prop, PropSync} from 'nuxt-property-decorator'
import {Writable} from 'type-fest'
import {Model<%= struct.name.pascalName %>, <%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request} from '~/apis'
import AppDataTable, {DataTablePageInfo, INITIAL_DATA_TABLE_PAGE_INFO} from '~/components/common/AppDataTable.vue'
<%_ if (struct.structType !== 'struct') { -%>
import <%= struct.name.pascalName %>SearchForm from '~/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>SearchForm.vue'
import {INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION} from '~/initials/<%= struct.name.pascalName %>Initials'
<%_ } -%>
import Base from '~/mixins/base'

<%_ if (struct.structType !== 'struct') { -%>
@Component({
  components: {
    AppDataTable,
    <%= struct.name.pascalName %>SearchForm
  }
})
<%_ } else { -%>
@Component({
  components: {AppDataTable}
})
<%_ } -%>
export default class <%= struct.name.pascalName %>DataTable extends mixins(Base) {
  /** ヘッダー定義 */
  headers = [
    <%_ if (struct.fields) { -%>
    <%_ struct.fields.forEach(function(field, index){ -%>
      <%_ if (field.listType !== 'none' && field.dataType !== 'struct' && field.dataType !== 'array-struct') { -%>
    {
      text: '<%= field.screenLabel ? field.screenLabel : field.name.lowerCamelName === 'id' ? 'ID' : field.name.lowerCamelName %>',
      align: '',
      value: '<%= field.name.lowerCamelName %>'
    },
    <%_ } -%>
    <%_ }); -%>
    <%_ } -%>
    {
      text: '',
      align: 'center',
      value: 'action',
      sortable: false
    }
  ]

  /** 一覧表示用の配列 */
  @Prop({type: Array})
  items!: Model<%= struct.name.pascalName %>[]

  /** 一覧の表示ページ情報 */
  @PropSync('pageInfo', {type: Object, default: () => cloneDeep(INITIAL_DATA_TABLE_PAGE_INFO)})
  syncedPageInfo!: DataTablePageInfo

  /** 一覧の合計件数 */
  @Prop({type: Number, default: undefined})
  totalCount!: number | undefined

  /** 一覧の読み込み状態 */
  @Prop({type: Boolean, default: false})
  isLoading!: boolean
<%_ if (struct.structType !== 'struct') { -%>

  /** 検索フォームの表示表示状態 (true: 表示, false: 非表示) */
  isSearchFormOpen: boolean = false

  /** 検索条件 */
  @PropSync('searchCondition', {type: Object, default: () => cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION)})
  syncedSearchCondition!: Writable<<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request>

  /** 表示方式 (true: 子要素として表示, false: 親要素として表示) */
  @Prop({type: Boolean, default: false})
  hasParent!: boolean

  get previewSearchCondition() {
    const previewSearchConditions = []
    for (const [key, value] of Object.entries(this.syncedSearchCondition)) {
      if (!value) {
        continue
      }
      previewSearchConditions.push(`${key}=${value}`)
    }
    return previewSearchConditions.join(', ')
  }
<%_ } -%>

  @Emit('onChangePageInfo')
  onChangePageInfo() {}
<%_ if (struct.structType !== 'struct') { -%>

  @Emit('onChangeSearch')
  onChangeSearch() {}

  search(searchCondition: Writable<<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request>) {
    this.syncedSearchCondition = searchCondition
    this.onChangeSearch()
  }
<%_ } -%>

  @Emit('clickRow')
  clickRow(item?: Model<%= struct.name.pascalName %>) {}

  @Emit('clickAdd')
  clickAdd() {}

  @Emit('remove')
  remove() {}
}
</script>

<style scoped>
.action-button {
  pointer-events: auto;
}

.carousel >>> .v-responsive__content {
  display: flex;
}

.carousel >>> .v-window__prev, .carousel >>> .v-window__next {
  margin: 0;
  top: calc(50% - 10px);
}
</style>
