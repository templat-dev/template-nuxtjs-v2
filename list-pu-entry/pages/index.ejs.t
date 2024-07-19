---
to: "<%= struct.generateEnable ? `${rootDirectory}/pages/${project.buildConfig.webPageRoot}${struct.name.lowerCamelName}/index.vue` : null %>"
---
<template>
  <v-layout>
    <<%= struct.name.pascalName %>DataTable
      :is-loading="isLoading"
      :items="<%= struct.name.lowerCamelPluralName %>"
      :page-info.sync="pageInfo"
      :search-condition.sync="searchCondition"
      :total-count="totalCount"
      class="elevation-1"
      @onChangePageInfo="reFetch"
      @onChangeSearch="reFetch"
      @openEntryForm="openEntryForm"
      @remove="removeRow"
    ></<%= struct.name.pascalName %>DataTable>
    <v-dialog v-model="isEntryFormOpen" max-width="800px" persistent>
      <<%= struct.name.pascalName %>EntryForm
        :is-new="editIndex === NEW_INDEX"
        :open.sync="isEntryFormOpen"
        :target.sync="editTarget"
        @remove="removeForm"
        @updated="reFetch"
      ></<%= struct.name.pascalName %>EntryForm>
    </v-dialog>
  </v-layout>
</template>

<script lang="ts">
import {Component, mixins} from 'nuxt-property-decorator'
import {cloneDeep} from 'lodash-es'
import {Context} from '@nuxt/types'
import {vxm} from '@/store'
import Base from '@/mixins/base'
import {<%= struct.name.pascalName %>Api, Model<%= struct.name.pascalPluralName %>, Model<%= struct.name.pascalName %>} from '@/apis'
import {DataTablePageInfo, INITIAL_DATA_TABLE_PAGE_INFO} from '@/components/common/AppDataTable.vue'
import <%= struct.name.pascalName %>DataTable from '@/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>DataTable.vue'
import {
  <%= struct.name.pascalName %>SearchCondition,
  INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION
} from '@/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>SearchForm.vue'
import <%= struct.name.pascalName %>EntryForm, {INITIAL_<%= struct.name.upperSnakeName %>} from '@/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>EntryForm.vue'

@Component({
  components: {
    <%= struct.name.pascalName %>DataTable,
    <%= struct.name.pascalName %>EntryForm
  },
<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>
  middleware: 'auth'
<%_ } -%>
})
export default class <%= struct.name.pascalPluralName %> extends mixins(Base) {
  /** 一覧表示用の配列 */
  <%= struct.name.lowerCamelPluralName %>: Model<%= struct.name.pascalName %>[] = []

  /** 一覧の表示ページ情報 */
  pageInfo = cloneDeep(INITIAL_DATA_TABLE_PAGE_INFO)

  /** 一覧の合計件数 */
  totalCount: number = 0

  /** 一覧の読み込み状態 */
  isLoading: boolean = false

  /** 検索条件 */
  searchCondition: <%= struct.name.pascalName %>SearchCondition = cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION)

  /** 入力フォームの表示表示状態 (true: 表示, false: 非表示) */
  isEntryFormOpen: boolean = false

  /** 編集対象 */
  editTarget: Model<%= struct.name.pascalName %> | null = null

  /** 編集対象のインデックス */
  editIndex: number = 0

  static async fetch(
    {searchCondition = INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION, pageInfo = INITIAL_DATA_TABLE_PAGE_INFO}
      : { searchCondition: <%= struct.name.pascalName %>SearchCondition, pageInfo: DataTablePageInfo }
      = {searchCondition: INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION, pageInfo: INITIAL_DATA_TABLE_PAGE_INFO}
  ): Promise<Model<%= struct.name.pascalPluralName %>> {
    return await new <%= struct.name.pascalName %>Api().search<%= struct.name.pascalName %>({
    <%_ struct.fields.forEach(function(field, index){ -%>
<%#_ 通常の検索 -%>
      <%_ if ((field.listType === 'string' || field.listType === 'time' || field.listType === 'bool' || field.listType === 'number')  && field.searchType === 1) { -%>
      <%= field.name.lowerCamelName %>: searchCondition.<%= field.name.lowerCamelName %> || undefined,
<%#_ 配列の検索 -%>
      <%_ } else if ((field.listType === 'array-string' || field.listType === 'array-time' || field.listType === 'array-bool' || field.listType === 'array-number')  && field.searchType === 1) { -%>
      <%= field.name.lowerCamelName %>: searchCondition.<%= field.name.lowerCamelName %> ? [searchCondition.<%= field.name.lowerCamelName %>] : undefined,
<%#_ 範囲検索 -%>
      <%_ } else if ((field.listType === 'time' || field.listType === 'number') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
      <%= field.name.lowerCamelName %>: searchCondition.<%= field.name.lowerCamelName %> || undefined,
      <%= field.name.lowerCamelName %>From: searchCondition.<%= field.name.lowerCamelName %>From || undefined,
      <%= field.name.lowerCamelName %>To: searchCondition.<%= field.name.lowerCamelName %>To || undefined,
<%#_ 配列の範囲検索 -%>
      <%_ } else if ((field.listType === 'array-time' || field.listType === 'array-number') && 2 <= field.searchType &&  field.searchType <= 5) { -%>
      <%= field.name.lowerCamelName %>: searchCondition.<%= field.name.lowerCamelName %> ? [searchCondition.<%= field.name.lowerCamelName %>] : undefined,
      <%= field.name.lowerCamelName %>From: searchCondition.<%= field.name.lowerCamelName %>From || undefined,
      <%= field.name.lowerCamelName %>To: searchCondition.<%= field.name.lowerCamelName %>To || undefined,
      <%_ } -%>
    <%_ }) -%>
      limit: pageInfo.itemsPerPage !== -1 ? pageInfo.itemsPerPage : undefined,
<%_ if (project.dbType === 'datastore') { -%>
      cursor: pageInfo.page !== 1 ? pageInfo.cursors[pageInfo.page - 2] : undefined,
      orderBy: pageInfo.sortBy.map((sb, i) => `${(pageInfo.sortDesc)[i] ? '-' : ''}${sb}`).join(',') || undefined
<%_ } else { -%>
      offset: (pageInfo.page - 1) * pageInfo.itemsPerPage,
      orderBy: pageInfo.sortBy.map((sb, i) => `${sb} ${(pageInfo.sortDesc)[i] ? 'desc' : 'asc'}`).join(',') || undefined
<%_ } -%>
    }).then(res => res.data)
  }

  async asyncData({}: Context) {
    const data = await <%= struct.name.pascalPluralName %>.fetch()
<%_ if (project.dbType === 'datastore') { -%>
    const pageInfo = cloneDeep(INITIAL_DATA_TABLE_PAGE_INFO)
    if (data.cursor) {
      pageInfo.cursors[0] = data.cursor
    }
    return {
      <%= struct.name.lowerCamelPluralName %>: data.<%= struct.name.lowerCamelPluralName %>,
      totalCount: data.count,
      pageInfo
    }
<%_ } else { -%>
    return {
      <%= struct.name.lowerCamelPluralName %>: data.<%= struct.name.lowerCamelPluralName %>,
      totalCount: data.count
    }
<%_ } -%>
  }

  async reFetch() {
    this.isLoading = true
    try {
      const data = await <%= struct.name.pascalPluralName %>.fetch({
        searchCondition: this.searchCondition,
        pageInfo: this.pageInfo
      })
<%_ if (project.dbType === 'datastore') { -%>
      if (data.cursor) {
        this.pageInfo.cursors[this.pageInfo.page - 1] = data.cursor
      }
<%_ } -%>
      this.<%= struct.name.lowerCamelPluralName %> = data.<%= struct.name.lowerCamelPluralName %> || []
      this.totalCount = data.count || 0
    } finally {
      this.isLoading = false
    }
  }

  openEntryForm(<%= struct.name.lowerCamelName %>?: Model<%= struct.name.pascalName %>) {
    if (!!<%= struct.name.lowerCamelName %>) {
      this.editTarget = cloneDeep(<%= struct.name.lowerCamelName %>)
      this.editIndex = this.<%= struct.name.lowerCamelPluralName %>.indexOf(<%= struct.name.lowerCamelName %>)
    } else {
      this.editTarget = cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>)
      this.editIndex = this.NEW_INDEX
    }
    this.isEntryFormOpen = true
  }

  removeRow(item: Model<%= struct.name.pascalName %>) {
    const index = this.<%= struct.name.lowerCamelPluralName %>.indexOf(item)
    this.remove(index)
  }

  removeForm() {
    this.remove(this.editIndex)
  }

  async remove(index: number) {
    vxm.app.showDialog({
      title: '削除確認',
      message: '削除してもよろしいですか？',
      negativeText: 'Cancel',
      positive: async () => {
        vxm.app.showLoading()
        try {
          await new <%= struct.name.pascalName %>Api().delete<%= struct.name.pascalName %>({id: this.<%= struct.name.lowerCamelPluralName %>[index].id!})
          this.isEntryFormOpen = false
          await this.reFetch()
        } finally {
          vxm.app.hideLoading()
        }
        vxm.app.showSnackbar({text: '削除しました。'})
      }
    })
  }
}
</script>

<style scoped></style>
