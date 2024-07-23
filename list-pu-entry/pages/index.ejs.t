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
      @clickAdd="openEntryForm"
      @clickRow="openEntryForm"
      @onChangePageInfo="reFetch"
      @onChangeSearch="reFetch"
      @openEntryForm="openEntryForm"
      @remove="remove"
    ></<%= struct.name.pascalName %>DataTable>
    <v-dialog v-model="isEntryFormOpen" max-width="800px" persistent>
      <<%= struct.name.pascalName %>EntryForm
        :open.sync="isEntryFormOpen"
        :target.sync="editTarget"
        @remove="remove"
        @updated="reFetch"
      ></<%= struct.name.pascalName %>EntryForm>
    </v-dialog>
  </v-layout>
</template>

<script lang="ts">
import {Context} from '@nuxt/types'
import {cloneDeep} from 'lodash-es'
import {Component, mixins} from 'nuxt-property-decorator'
import {Writable} from 'type-fest'
import {<%= struct.name.pascalName %>Api, <%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request, Model<%= struct.name.pascalName %>, Model<%= struct.name.pascalPluralName %>} from '~/apis'
import {DataTablePageInfo, INITIAL_DATA_TABLE_PAGE_INFO} from '~/components/common/AppDataTable.vue'
import <%= struct.name.pascalName %>DataTable from '~/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>DataTable.vue'
import <%= struct.name.pascalName %>EntryForm from '~/components/<%= struct.name.lowerCamelName %>/<%= struct.name.pascalName %>EntryForm.vue'
import {INITIAL_<%= struct.name.upperSnakeName %>, INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION} from '~/initials/<%= struct.name.pascalName %>Initials'
import Base from '~/mixins/base'
import {vxm} from '~/store'

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
  searchCondition: Writable<<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request> = cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION)

  /** 入力フォームの表示表示状態 (true: 表示, false: 非表示) */
  isEntryFormOpen: boolean = false

  /** 編集対象 */
  editTarget: Model<%= struct.name.pascalName %> | null = null

  /** 編集対象のインデックス */
  editIndex: number = 0

  static async fetch(
    {searchCondition = INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION, pageInfo = INITIAL_DATA_TABLE_PAGE_INFO}
      : { searchCondition: Writable<<%= struct.name.pascalName %>ApiSearch<%= struct.name.pascalName %>Request>, pageInfo: DataTablePageInfo }
      = {searchCondition: INITIAL_<%= struct.name.upperSnakeName %>_SEARCH_CONDITION, pageInfo: INITIAL_DATA_TABLE_PAGE_INFO}
  ): Promise<Model<%= struct.name.pascalPluralName %>> {
    return await new <%= struct.name.pascalName %>Api().search<%= struct.name.pascalName %>({
      ...searchCondition,
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
    } else {
      this.editTarget = cloneDeep(INITIAL_<%= struct.name.upperSnakeName %>)
    }
    this.isEntryFormOpen = true
  }

  async remove(<%= struct.name.lowerCamelName %>?: Model<%= struct.name.pascalName %>) {
    <%= struct.name.lowerCamelName %> = <%= struct.name.lowerCamelName %> || this.editTarget!
    vxm.app.showDialog({
      title: '削除確認',
      message: '削除してもよろしいですか？',
      negativeText: 'Cancel',
      positive: async () => {
        vxm.app.showLoading()
        try {
          await new <%= struct.name.pascalName %>Api().delete<%= struct.name.pascalName %>({id: <%= struct.name.lowerCamelName %>!.id!})
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
