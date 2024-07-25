#include <vector>
#include <string>
class Solution {
public:
    int findMaxForm(vector<string>& strs, int m, int n) {
        vector<vector<int>> dp(m+1, vector<int>(n+1, 0));
        for(auto str : strs){ // 遍历物品
            int zeroNum = 0, oneNum = 0;
            for(char c : str){
                if(c == '0') zeroNum++;
                else oneNum++;
            }
            //遍历背包
            for(int i = m; i >= zeroNum; i--){
                for(int j = n; j >= oneNum; j--){
                    dp[i][j] = max(dp[i][j], dp[i-zeroNum][j-oneNum]+1);
                }
            }
        }
        return dp[m][n];
    }
};